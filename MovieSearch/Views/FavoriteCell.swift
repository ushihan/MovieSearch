//
//  FavoriteCell.swift
//  MovieSearch
//
//  Created by Shih-Han Hsu on 20/2/2024.
//

import Foundation
import UIKit

class FavoriteCell: UICollectionViewCell {

    var buttonAction: (() -> Void)?

    static let identifier = "FavoriteCell"

    private var posterImageView: UIImageView = {
        let imageView = RoundImageView(roundingCorners: [.topRight])
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    private let favoriteButton: UIButton = {
        let button = RoundButton()
        var config = UIButton.Configuration.filled()
        config.image = UIImage(named: "star_fill")
        config.background.backgroundColor = .white
        button.configuration = config
        return button
    }()

    private let scoreLabel = UILabel(textColor: .black, font: .setToInterReular(isBold: false, size: 20), textAlignment: .center)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with movie: MovieItem) {
        setupInformation(with: movie)
        favoriteButton.addAction(UIAction { _ in
            self.buttonAction?()
        }, for: .touchUpInside)
    }

    private func setupInformation(with movie: MovieItem) {
        posterImageView.image = movie.image
        scoreLabel.text = movie.myRating ?? "0"
    }

    private func setupViews() {
        let titleLabel = UILabel(text: "My Rating", textColor: .black, font: .setToInterReular(isBold: false, size: 16), textAlignment: .center)
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
