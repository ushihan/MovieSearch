//
//  MovieRatingView.swift
//  MovieSearch
//
//  Created by Shih-Han Hsu on 20/2/2024.
//

import Foundation
import UIKit

class MovieRatingView: UIView {

    private var movie: MovieItem

    let backButton: UIButton = {
        let button = RoundButton()
        button.tintColor = .white

        var config = UIButton.Configuration.filled()
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 10)
        config.image = UIImage(systemName: "chevron.backward",
                               withConfiguration: imageConfig)?.withTintColor(.white, renderingMode: .alwaysOriginal)
        config.background.backgroundColor = .white.withAlphaComponent(0.3)
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white,
            .font: UIFont.systemFont(ofSize: 10)
        ]
        config.attributedTitle = AttributedString("Back to Search", attributes: AttributeContainer(attributes))
        config.imagePadding = 10
        config.contentInsets = NSDirectionalEdgeInsets(top: 7, leading: 24, bottom: 7, trailing: 24)
        button.configuration = config

        return button
    }()

    let favoriteButton: UIButton = {
        let button = RoundButton()
        var config = UIButton.Configuration.filled()
        config.image = UIImage(named: "star")
        config.background.backgroundColor = .white
        button.configuration = config
        return button
    }()

    let rateButton: UIButton = {
        let buttonStyleModel = TwoPartStyleModel(topColor: UIColor(hex: "#AB803F"), topText: "Rate it myself >",
                                                 topTextColor: .white, topFont: .systemFont(ofSize: 16),
                                                 bottomColor: .black, bottomText: "add personal rating",
                                                 bottomTextColor: UIColor(hex: "#D7BA8E"),
                                                 bottomFont: .systemFont(ofSize: 12))
        return TwoPartButton(style: buttonStyleModel)
    }()

    let viewFavsButton: UIButton = {
        let button = RoundButton()
        var config = UIButton.Configuration.filled()
        config.background.backgroundColor = .white
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.black,
            .font: UIFont.systemFont(ofSize: 16)
        ]
        config.attributedTitle = AttributedString("Go to favourites", attributes: AttributeContainer(attributes))
        button.configuration = config

        return button
    }()

    init(with movie: MovieItem) {
        self.movie = movie
        super.init(frame: .zero)
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLayout() {
        backgroundColor = UIColor(hex: "#A5E8B4")

        let backgroundImageView = getHeaderImageView()
        let titleLabel = UILabel(text: movie.title, textColor: .white,
                                 font: .preferredFont(forTextStyle: .largeTitle))
        let subtitleLabel = UILabel(text: "You rated this", textColor: .white,
                                    font: .preferredFont(forTextStyle: .body))

        let posterImageView = RoundImageView(roundingCorners: [.topRight], borderWidth: 5)
        posterImageView.loadImage(from: movie.imageURL)
        posterImageView.contentMode = .scaleAspectFill

        let rateButton = rateButton.setShadow()
        let viewFavsButton = viewFavsButton.setShadow()

        addSubview(backgroundImageView)
        addSubview(backButton)
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        addSubview(posterImageView)
        addSubview(favoriteButton)
        addSubview(rateButton)
        addSubview(viewFavsButton)

        backgroundImageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalTo(self.snp.centerY)
        }

        backButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(34)
            make.top.equalTo(safeAreaLayoutGuide.snp.top).inset(31)
        }

        titleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(32)
            make.top.equalTo(backButton.snp.bottom).offset(18)
        }

        subtitleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(32)
            make.top.equalTo(titleLabel.snp.bottom).offset(15)
        }

        posterImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.equalTo(162)
            make.width.equalTo(120)
        }

        favoriteButton.snp.makeConstraints { make in
            make.bottom.equalTo(posterImageView.snp.top)
            make.leading.equalTo(posterImageView.snp.trailing)
            make.height.width.equalTo(48)
        }

        rateButton.snp.makeConstraints { make in
            make.top.equalTo(posterImageView.snp.bottom).offset(27)
            make.leading.trailing.equalToSuperview().inset(114)
            make.height.equalTo(56)
        }

        viewFavsButton.snp.makeConstraints { make in
            make.top.equalTo(rateButton.snp.bottom).offset(21)
            make.leading.trailing.equalToSuperview().inset(50)
            make.height.equalTo(56)
        }
    }

    private func getHeaderImageView() -> UIView {
        let imageView = UIImageView()
        imageView.loadImage(from: movie.backdropImageURL)
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        let maskView = UIView()
        maskView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        maskView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        imageView.addSubview(maskView)

        return imageView
    }
}
