//
//  FavoriteViewController.swift
//  MovieSearch
//
//  Created by Shih-Han Hsu on 20/2/2024.
//

import Foundation
import UIKit

class FavoriteViewController: UIViewController {

    weak var coordinator: AppCoordinator?

    private var dataSource: UICollectionViewDiffableDataSource<FavoriteSection, FavoriteItem>!

    private var customView: FavoriteView {
        guard let view = view as? FavoriteView else {
            fatalError("view should be FavoriteView")
        }
        return view
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

        dataSource = UICollectionViewDiffableDataSource<FavoriteSection, FavoriteItem>(collectionView: customView.collectionView) { (collectionView, indexPath, item) -> UICollectionViewCell? in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FavoriteCell.identifier, for: indexPath) as? FavoriteCell else {
                fatalError("Cannot create new cell")
            }
            cell.configure(with: item)
            return cell
        }

        var snapshot = NSDiffableDataSourceSnapshot<FavoriteSection, FavoriteItem>()
        snapshot.appendSections([.main])
        snapshot.appendItems([FavoriteItem(id: "000", 
                                           imageURL: "https://image.tmdb.org/t/p/w500/pWsD91G2R1Da3AKM3ymr3UoIfRb.jpg", score: "100"),
                              FavoriteItem(id: "111",
                                           imageURL: "https://image.tmdb.org/t/p/w500/pWsD91G2R1Da3AKM3ymr3UoIfRb.jpg", score: "32"),
                              FavoriteItem(id: "222",
                                           imageURL: "https://image.tmdb.org/t/p/w500/pWsD91G2R1Da3AKM3ymr3UoIfRb.jpg", score: "99"),
                              FavoriteItem(id: "333",
                                           imageURL: "https://image.tmdb.org/t/p/w500/pWsD91G2R1Da3AKM3ymr3UoIfRb.jpg", score: "40"),
                              FavoriteItem(id: "555",
                                           imageURL: "https://image.tmdb.org/t/p/w500/pWsD91G2R1Da3AKM3ymr3UoIfRb.jpg", score: "0")])
        dataSource.apply(snapshot, animatingDifferences: false)
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
