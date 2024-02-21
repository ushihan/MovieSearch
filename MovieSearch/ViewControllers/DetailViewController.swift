//
//  DetailViewController.swift
//  MovieSearch
//
//  Created by Shih-Han Hsu on 19/2/2024.
//

import Foundation
import UIKit
import Combine

class DetailViewController: UIViewController {

    weak var coordinator: AppCoordinator?
    private let viewModel: DetailViewModel
    private var cancellables = Set<AnyCancellable>()

    private var customView: MovieDetailView {
        guard let view = view as? MovieDetailView else {
            fatalError("view should be MovieDetailView")
        }
        return view
    }

    override func loadView() {
        view = MovieDetailView()
    }

    init(viewModel: DetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)

        viewModel.$isFavorite
            .receive(on: RunLoop.main)
            .sink { [weak self] isFavorite in
                guard let self = self else { return }
                self.customView.updateView(movie: self.viewModel.movie, isFavorite: isFavorite)
            }
            .store(in: &cancellables)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupAction()
    }

    private func setupAction() {
        customView.backButton.addAction(UIAction { [weak self] _ in
            self?.dismiss(animated: true)
        }, for: .touchUpInside)

        customView.rateButton.addAction(UIAction { [weak self] _ in
            guard let self = self else { return }
            self.coordinator?.navigateToRating(with: self.viewModel.movie)
        }, for: .touchUpInside)

        customView.viewFavsButton.addAction(UIAction { [weak self] _ in
            self?.coordinator?.navigateToFavorite()
        }, for: .touchUpInside)

        customView.favoriteButton.addAction(UIAction { [weak self] _ in
            guard let viewModel = self?.viewModel else { return }
            viewModel.setFavorite(movie: viewModel.movie, favorite: !viewModel.isFavorite)
        }, for: .touchUpInside)
    }
}
