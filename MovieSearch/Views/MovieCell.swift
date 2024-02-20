//
//  MovieCell.swift
//  MovieSearch
//
//  Created by Shih-Han Hsu on 18/2/2024.
//

import Foundation
import UIKit

class MovieCell: UITableViewCell {

    static let identifier = "FavoriteCell"

    // MARK: - components

    private lazy var movieImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        return imageView
    }()

    private let titleLabel = UILabel(textColor: .black, font: .systemFont(ofSize: 16, weight: .bold))
    private let releaseYearLabel = UILabel(textColor: UIColor(hex: "#959595"), font: .systemFont(ofSize: 12))
    private let scoreLabel = UILabel(textColor: .black, font: .systemFont(ofSize: 12, weight: .bold))

    private lazy var scoreContainer: UIView = {
        let userScoreLabel = UILabel(text: "user score", textColor: .black, font: .systemFont(ofSize: 12))
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

    private lazy var genreContainer: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 12
        return stackView
    }()

    // MARK: - set up data

    func configure(with movie: MovieItem) {
        setupInformation(with: movie)
        setupViews()
    }

    private func setupInformation(with movie: MovieItem) {
        titleLabel.text = movie.title
        releaseYearLabel.text = movie.releaseYear
        scoreLabel.text = movie.userScore + "%"

        if let imageURL = movie.imageURL {
            movieImageView.loadImage(from: imageURL)
        }

        movie.genreList.forEach { genre in
            let label = UILabel(text: genre, textColor: UIColor(hex: "#959595"), font: .systemFont(ofSize: 12))
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

    // MARK: - set up views

    private func setupViews() {
        let informationView = getInformationView()

        addSubview(movieImageView)
        addSubview(informationView)

        movieImageView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(10)
            make.leading.equalToSuperview().inset(34)
            make.width.equalTo(85)
        }

        informationView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(10)
            make.trailing.equalToSuperview().inset(34)
            make.leading.equalTo(movieImageView.snp.trailing).offset(27)
        }
    }

    private func getInformationView() -> UIView {
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
