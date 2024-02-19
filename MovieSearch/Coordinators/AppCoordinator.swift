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

    init(window: UIWindow) {
        self.window = window
    }

    func start() {
        let viewModel = MoviesViewModel()
        let moviesViewController = MoviesViewController(viewModel: viewModel)
        moviesViewController.coordinator = self
        window.rootViewController = moviesViewController
    }

    func navigateToDetail(model: MovieDetailModel) {
        let detailViewController = MovieDetailViewController(model: model)
        detailViewController.modalPresentationStyle = .fullScreen
        detailViewController.modalTransitionStyle = .coverVertical
        window.rootViewController?.present(detailViewController, animated: true)
    }
}
