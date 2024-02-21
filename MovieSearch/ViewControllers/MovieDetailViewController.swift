//
//  MovieDetailViewController.swift
//  MovieSearch
//
//  Created by Shih-Han Hsu on 19/2/2024.
//

import Foundation
import UIKit

class MovieDetailViewController: UIViewController {

    weak var coordinator: AppCoordinator?
    private let viewModel: MovieDetailViewModel
    private var movie: MovieItem

    private var customView: MovieDetailView {
        guard let view = view as? MovieDetailView else {
            fatalError("view should be MovieDetailView")
        }
        return view
    }

    override func loadView() {
        view = MovieDetailView(with: movie)
    }

    init(with movie: MovieItem, viewModel: MovieDetailViewModel) {
        self.movie = movie
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
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
            self.coordinator?.navigateToRating(with: self.movie)
        }, for: .touchUpInside)

        customView.viewFavsButton.addAction(UIAction { [weak self] _ in
            self?.coordinator?.navigateToFavorite()
        }, for: .touchUpInside)
    }
}
