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
    private var movieDataStore: MovieDataStore

    private var topViewController: UIViewController? {
        var topViewController = window.rootViewController
        while let presentedViewController = topViewController?.presentedViewController {
            topViewController = presentedViewController
        }
        return topViewController
    }

    init(window: UIWindow) {
        self.window = window
        self.movieDataStore = MovieDataStore()
    }

    func start() {
        let viewModel = MoviesViewModel(movieDataStore: movieDataStore)
        let moviesViewController = MoviesViewController(viewModel: viewModel)
        moviesViewController.coordinator = self
        window.rootViewController = moviesViewController
    }

    func navigateToDetail(with movie: MovieItem) {
        let viewModel = DetailViewModel(with: movie, movieDataStore: movieDataStore)
        let detailViewController = DetailViewController(viewModel: viewModel)
        detailViewController.modalPresentationStyle = .overFullScreen
        detailViewController.modalTransitionStyle = .coverVertical
        detailViewController.coordinator = self
        topViewController?.present(detailViewController, animated: true)
    }

    func navigateToRating(with movie: MovieItem) {
        let viewModel = RatingViewModel(with: movie, movieDataStore: movieDataStore)
        let ratingViewController = RatingViewController(viewModel: viewModel)
        ratingViewController.modalPresentationStyle = .overFullScreen
        ratingViewController.modalTransitionStyle = .coverVertical
        ratingViewController.coordinator = self
        topViewController?.dismiss(animated: false)
        window.rootViewController?.present(ratingViewController, animated: true)
    }

    func navigateToFavorite() {
        let viewModel = FavoriteViewModel(movieDataStore: movieDataStore)
        let favoriteViewController = FavoriteViewController(viewModel: viewModel)
        favoriteViewController.modalPresentationStyle = .fullScreen
        favoriteViewController.modalTransitionStyle = .coverVertical
        favoriteViewController.coordinator = self
        topViewController?.present(favoriteViewController, animated: true)
    }

    func navigateToSearch() {
        let viewModel = MoviesViewModel(movieDataStore: movieDataStore)
        let moviesViewController = MoviesViewController(viewModel: viewModel)
        moviesViewController.coordinator = self

        moviesViewController.view.frame = CGRect(x: 0, y: window.bounds.height, width: window.bounds.width, height: window.bounds.height)
        window.addSubview(moviesViewController.view)

        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            guard let self = self else { return }
            moviesViewController.view.frame = CGRect(x: 0, y: 0, width: self.window.bounds.width, height: self.window.bounds.height)
        }) { [weak self] _ in
            guard let self = self else { return }
            self.window.rootViewController = moviesViewController
        }
    }
}
