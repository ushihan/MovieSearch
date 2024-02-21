//
//  FavoriteViewController.swift
//  MovieSearch
//
//  Created by Shih-Han Hsu on 20/2/2024.
//

import Foundation
import UIKit
import Combine

class FavoriteViewController: UIViewController {

    weak var coordinator: AppCoordinator?
    private let viewModel: FavoriteViewModel
    private var cancellables = Set<AnyCancellable>()
    private var dataSource: UICollectionViewDiffableDataSource<MovieSection, MovieItem>?

    private var customView: FavoriteView {
        guard let view = view as? FavoriteView else {
            fatalError("view should be FavoriteView")
        }
        return view
    }

    init(viewModel: FavoriteViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = FavoriteView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupAction()
    }

    private func setupCollectionView() {
        customView.collectionView.register(FavoriteCell.self, forCellWithReuseIdentifier: FavoriteCell.identifier)

        dataSource = UICollectionViewDiffableDataSource<MovieSection, MovieItem>(collectionView: customView.collectionView) { (collectionView, indexPath, item) -> UICollectionViewCell? in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FavoriteCell.identifier, for: indexPath) as? FavoriteCell else {
                fatalError("Cannot create new cell")
            }
            cell.configure(with: item)
            cell.buttonAction = {
                self.viewModel.setFavorite(movie: item, favorite: false)
            }
            return cell
        }

        viewModel.$movies
            .receive(on: RunLoop.main)
            .sink { [weak self] movies in
                var snapshot = NSDiffableDataSourceSnapshot<MovieSection, MovieItem>()
                snapshot.appendSections([.main])
                snapshot.appendItems(movies)
                self?.dataSource?.apply(snapshot, animatingDifferences: true)
            }.store(in: &cancellables)
    }

    private func setupAction() {
        customView.backButton.addAction(UIAction { [weak self] _ in
            self?.dismiss(animated: true)
        }, for: .touchUpInside)

        customView.searchButton.addAction(UIAction { [weak self] _ in
            self?.coordinator?.navigateToSearch()
        }, for: .touchUpInside)
    }
}
