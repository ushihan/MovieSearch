//
//  MovieDetailViewController.swift
//  MovieSearch
//
//  Created by Shih-Han Hsu on 19/2/2024.
//

import Foundation
import UIKit

class MovieDetailViewController: UIViewController {

    private var customView: MovieDetailView {
        guard let view = view as? MovieDetailView else {
            fatalError("view should be MovieDetailView")
        }
        return view
    }

    private var detailModel: MovieItem

    override func loadView() {
        view = MovieDetailView(detailModel: detailModel)
    }

    init(model: MovieItem) {
        self.detailModel = model
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
    }
}
