//
//  FavoriteCell.swift
//  MovieSearch
//
//  Created by Shih-Han Hsu on 20/2/2024.
//

import Foundation
import UIKit

class FavoriteCell: UICollectionViewCell {

    static let identifier = "FavoriteCell"

    private var posterImageView: UIImageView = {
        let imageView = RoundImageView(roundingCorners: [.topRight])
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    let favoriteButton: UIButton = {
        let button = RoundButton()
        var config = UIButton.Configuration.filled()
        config.image = UIImage(named: "star_fill")
        config.background.backgroundColor = .white
        button.configuration = config
        return button
    }()

    private let scoreLabel = UILabel(textColor: .black, font: .systemFont(ofSize: 20), textAlignment: .center)

    func configure(with movie: FavoriteItem) {
        setupInformation(with: movie)
        setupViews()
    }

    private func setupInformation(with movie: FavoriteItem) {
        posterImageView.loadImage(from: movie.imageURL)
        scoreLabel.text = movie.score
    }

    private func setupViews() {
        let titleLabel = UILabel(text: "My Rating", textColor: .black, font: .systemFont(ofSize: 16), textAlignment: .center)
        let favoriteButton = favoriteButton.setShadow()

        addSubview(posterImageView)
        addSubview(favoriteButton)
        addSubview(titleLabel)
        addSubview(scoreLabel)

        posterImageView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(162)
            make.width.equalTo(120)
        }

        favoriteButton.snp.makeConstraints { make in
            make.centerY.equalTo(posterImageView.snp.bottom)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(48)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(favoriteButton.snp.bottom).offset(13)
            make.centerX.equalToSuperview()
        }

        scoreLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
        }

    }
}
