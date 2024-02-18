//
//  MovieCell.swift
//  MovieSearch
//
//  Created by Shih-Han Hsu on 18/2/2024.
//

import Foundation
import UIKit

class MovieCell: UITableViewCell {

    // MARK: - components

    private lazy var movieImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        return imageView
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textAlignment = .left
        return label
    }()

    private lazy var releaseYearLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(hex: "#959595")
        label.font = .systemFont(ofSize: 12)
        label.textAlignment = .left
        return label
    }()

    private lazy var scoreContainer: UIView = {
        let view = UIView()
        view.addSubview(scoreLabel)
        view.addSubview(userScoreLabel)

        scoreLabel.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
        }

        userScoreLabel.snp.makeConstraints { make in
            make.leading.equalTo(scoreLabel.snp.trailing).offset(7)
            make.top.bottom.equalToSuperview()
        }

        return view
    }()

    private lazy var scoreLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 12, weight: .bold)
        label.textAlignment = .left

        return label
    }()

    private var userScoreLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 12)
        label.textAlignment = .left
        label.text = "user score"
        return label
    }()

    private lazy var genreContainer: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 12
        return stackView
    }()

    // MARK: - set up data

    func configure(with model: MovieItem) {
        setupInformation(with: model)
        setupViews()
    }

    func setupInformation(with model: MovieItem) {
        if let imageUrl = URL(string: model.imageURL) {
            loadImage(from: imageUrl)
        }

        titleLabel.text = model.title
        releaseYearLabel.text = model.releaseYear
        scoreLabel.text = model.userScore + "%"

        model.genreList.forEach { genre in
            let label = UILabel()
            label.textColor = UIColor(hex: "#959595")
            label.font = .systemFont(ofSize: 12)
            label.textAlignment = .left
            label.text = genre

            let view = UIView()
            view.backgroundColor = UIColor(hex: "#E6E6E6")
            view.addSubview(label)
            label.snp.makeConstraints { make in
                make.top.bottom.equalToSuperview().inset(3)
                make.leading.trailing.equalToSuperview().inset(6)
            }

            genreContainer.addArrangedSubview(view)
        }

        DispatchQueue.main.async { [weak self] in
            self?.genreContainer.arrangedSubviews.forEach { subview in
                subview.layer.cornerRadius = subview.frame.height / 2
            }
        }
    }

    func loadImage(from url: URL) {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            if let imageData = try? Data(contentsOf: url), let image = UIImage(data: imageData) {
                DispatchQueue.main.async {
                    self?.movieImageView.image = image
                }
            }
        }
    }

    // MARK: - set up views

    func setupViews() {
        let informationView = getInformationView()

        addSubview(movieImageView)
        addSubview(informationView)

        movieImageView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(10)
            make.leading.equalToSuperview().inset(24)
            make.width.equalTo(85)
        }

        informationView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(10)
            make.trailing.equalToSuperview().inset(24)
            make.leading.equalTo(movieImageView.snp.trailing).offset(27)
        }
    }

    func getInformationView() -> UIView {
        let informationContainer = UIStackView()
        informationContainer.axis = .vertical
        informationContainer.distribution = .equalSpacing
        informationContainer.spacing = 5

        informationContainer.addArrangedSubview(titleLabel)
        informationContainer.addArrangedSubview(releaseYearLabel)
        informationContainer.addArrangedSubview(scoreContainer)

        let view = UIView()
        view.addSubview(informationContainer)
        view.addSubview(genreContainer)

        informationContainer.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
        }

        genreContainer.snp.makeConstraints { make in
            make.bottom.leading.equalToSuperview()
            make.top.equalTo(informationContainer.snp.bottom).offset(18)
        }

        return view
    }
}
