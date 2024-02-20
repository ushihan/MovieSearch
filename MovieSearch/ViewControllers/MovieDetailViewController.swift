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

    private var customView: MovieDetailView {
        guard let view = view as? MovieDetailView else {
            fatalError("view should be MovieDetailView")
        }
        return view
    }

    private var movie: MovieItem

    override func loadView() {
        view = MovieDetailView(with: movie)
    }

    init(with movie: MovieItem) {
        self.movie = movie
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
        // set up button event: backButton, favoriteButton, rateButton, viewFavsButton
        customView.backButton.addAction(UIAction { [weak self] _ in
            self?.dismiss(animated: true)
        }, for: .touchUpInside)

        customView.rateButton.addAction(UIAction { [weak self] _ in
            guard let self = self else { return }
            self.coordinator?.navigateToRating(with: self.movie)
        }, for: .touchUpInside)
    }
}
