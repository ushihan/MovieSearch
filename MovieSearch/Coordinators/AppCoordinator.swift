//
//  AppCoordinator.swift
//  MovieSearch
//
//  Created by Shih-Han Hsu on 19/2/2024.
//

import Foundation
import UIKit

protocol Coordinator {
    func start()
}

class AppCoordinator: Coordinator {

    var window: UIWindow

    private var topViewController: UIViewController? {
        var topViewController = window.rootViewController
        while let presentedViewController = topViewController?.presentedViewController {
            topViewController = presentedViewController
        }
        return topViewController
    }

    init(window: UIWindow) {
        self.window = window
    }

    func start() {
        let viewModel = MoviesViewModel()
        let moviesViewController = MoviesViewController(viewModel: viewModel)
        moviesViewController.coordinator = self
        window.rootViewController = moviesViewController
    }

    func navigateToDetail(with movie: MovieItem) {
        let detailViewController = MovieDetailViewController(with: movie)
        detailViewController.modalPresentationStyle = .fullScreen
        detailViewController.modalTransitionStyle = .coverVertical
        detailViewController.coordinator = self
        topViewController?.present(detailViewController, animated: true)
    }

    func navigateToRating(with movie: MovieItem) {
        let ratingViewController = MovieRatingViewController(with: movie)
        ratingViewController.modalPresentationStyle = .fullScreen
        ratingViewController.modalTransitionStyle = .coverVertical
        ratingViewController.coordinator = self
        topViewController?.present(ratingViewController, animated: true)
    }
}
