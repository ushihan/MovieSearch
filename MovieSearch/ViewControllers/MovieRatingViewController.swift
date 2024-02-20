//
//  MovieRatingViewController.swift
//  MovieSearch
//
//  Created by Shih-Han Hsu on 20/2/2024.
//

import Foundation
import UIKit

class MovieRatingViewController: UIViewController {

    weak var coordinator: AppCoordinator?

    private var customView: MovieRatingView {
        guard let view = view as? MovieRatingView else {
            fatalError("view should be MovieRatingView")
        }
        return view
    }

    private var movie: MovieItem

    override func loadView() {
        view = MovieRatingView(with: movie)
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
        customView.backButton.addAction(UIAction { [weak self] _ in
            self?.dismiss(animated: true)
        }, for: .touchUpInside)

        customView.viewFavsButton.addAction(UIAction { [weak self] _ in
            self?.coordinator?.navigateToFavorite()
        }, for: .touchUpInside)
    }
}
