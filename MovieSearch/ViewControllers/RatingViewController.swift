//
//  RatingViewController.swift
//  MovieSearch
//
//  Created by Shih-Han Hsu on 20/2/2024.
//

import Foundation
import UIKit
import Combine

class RatingViewController: UIViewController {

    weak var coordinator: AppCoordinator?
    private let viewModel: RatingViewModel
    private var cancellables = Set<AnyCancellable>()

    private var customView: RatingView {
        guard let view = view as? RatingView else {
            fatalError("view should be MovieRatingView")
        }
        return view
    }

    override func loadView() {
        view = RatingView()
    }

    init(viewModel: RatingViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)

        viewModel.$isFavorite
            .combineLatest(viewModel.$movie)
            .receive(on: RunLoop.main)
            .sink { [weak self] isFavorite, movie in
                guard let self = self else { return }
                self.customView.updateView(movie: movie, isFavorite: isFavorite)
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
            self?.coordinator?.navigateToSearch()
        }, for: .touchUpInside)

        customView.viewFavsButton.addAction(UIAction { [weak self] _ in
            self?.coordinator?.navigateToFavorite()
        }, for: .touchUpInside)

        customView.favoriteButton.addAction(UIAction { [weak self] _ in
            guard let viewModel = self?.viewModel else { return }
            viewModel.setFavorite(movie: viewModel.movie, favorite: !viewModel.isFavorite)
        }, for: .touchUpInside)

        customView.rateButton.addAction(UIAction { [weak self] _ in
            if self?.viewModel.movie.myRating == nil {
                self?.showInputAlert()
            } else {
                self?.viewModel.resetRating()
            }
        }, for: .touchUpInside)
    }

    private func showInputAlert() {
        let alertController = UIAlertController(title: "Your Rating", message: nil, preferredStyle: .alert)

        alertController.addTextField { textField in
            textField.placeholder = "Enter your rating 0 ~ 10"
            textField.keyboardType = .decimalPad
        }

        let submitAction = UIAlertAction(title: "Submit", style: .default) { [weak alertController] _ in
            guard let text = alertController?.textFields?.first?.text, let score = Float(text), score <= 10, score >= 0 else {
                self.showErrorAlert(message: "Please enter a valid number")
                return
            }

            self.viewModel.setRating(score: score, errorHandle: self.showErrorAlert)
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)

        alertController.addAction(submitAction)
        alertController.addAction(cancelAction)

        present(alertController, animated: true)
    }
}
