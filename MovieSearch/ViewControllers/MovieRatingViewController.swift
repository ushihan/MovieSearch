//
//  MovieRatingViewController.swift
//  MovieSearch
//
//  Created by Shih-Han Hsu on 20/2/2024.
//

import Foundation
import UIKit
import Combine

class MovieRatingViewController: UIViewController {

    weak var coordinator: AppCoordinator?
    private let viewModel: RatingViewModel
    private var cancellables = Set<AnyCancellable>()

    private var customView: MovieRatingView {
        guard let view = view as? MovieRatingView else {
            fatalError("view should be MovieRatingView")
        }
        return view
    }

    override func loadView() {
        view = MovieRatingView()
    }

    init(viewModel: RatingViewModel) {
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

        customView.viewFavsButton.addAction(UIAction { [weak self] _ in
            self?.coordinator?.navigateToFavorite()
        }, for: .touchUpInside)

        customView.favoriteButton.addAction(UIAction { [weak self] _ in
            guard let viewModel = self?.viewModel else { return }
            viewModel.setFavorite(movie: viewModel.movie, favorite: !viewModel.isFavorite)
        }, for: .touchUpInside)
    }
}
