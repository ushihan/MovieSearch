//
//  MovieDetailView.swift
//  MovieSearch
//
//  Created by Shih-Han Hsu on 19/2/2024.
//

import Foundation
import UIKit

class MovieDetailView: UIView {

    let backButton: UIButton = {
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

        let button = RoundButton()
        button.configuration = config

        return button
    }()

    lazy var favoriteButton: UIButton = {
        let button = RoundButton()
        var config = UIButton.Configuration.filled()
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
        config.background.backgroundColor = UIColor(hex: "#FFF3D3")
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor(hex: "#B98E1E"),
            .font: UIFont.systemFont(ofSize: 16)
        ]
        config.attributedTitle = AttributedString("View Favs", attributes: AttributeContainer(attributes))
        button.configuration = config

        return button
    }()

    private let posterImageView = RoundImageView(roundingCorners: [.topRight], borderWidth: 5)
    private let headerLabel = UILabel(textColor: .white, font: .preferredFont(forTextStyle: .largeTitle))
    private let titleLabel = UILabel(textColor: .black, font: .systemFont(ofSize: 16, weight: .bold))
    private let releaseLabel = UILabel(textColor: UIColor(hex: "#959595"), font: .systemFont(ofSize: 12))
    private let scoreLabel = UILabel()

    private var scoreProgressView: UIProgressView = {
        let progressView = UIProgressView(progressViewStyle: .default)
        progressView.progressTintColor = UIColor(hex: "#4CAB4A")
        return progressView
    }()

    private var headerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true

        let maskView = UIView()
        maskView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        maskView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        imageView.addSubview(maskView)

        return imageView
    }()

    private var genreContainer: UIStackView = {
        let container = UIStackView()
        container.axis = .horizontal
        container.spacing = 8
        return container
    }()

    private var overviewTextView: UITextView = {
        let textView = UITextView()
        textView.font = .systemFont(ofSize: 16)
        textView.textColor = .black
        textView.isEditable = false
        textView.isScrollEnabled = true
        return textView
    }()

    init() {
        super.init(frame: .zero)
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func updateView(movie: MovieItem, isFavorite: Bool) {
        headerLabel.text = movie.title
        titleLabel.text = movie.title
        releaseLabel.text = movie.releaseYear
        favoriteButton.configuration?.image = isFavorite ? UIImage(named: "star_fill") : UIImage(named: "star")
        scoreProgressView.progress = (Float(movie.userScore) ?? 0) / 100
        overviewTextView.text = movie.overview

        if let imageURL = movie.imageURL {
            posterImageView.contentMode = .scaleAspectFill
            posterImageView.loadImage(from: imageURL)
        }

        if let imageURL = movie.backdropImageURL {
            headerImageView.loadImage(from: imageURL)
        }

        movie.genreList.forEach { genre in
            let label = UILabel(text: genre, textColor: UIColor(hex: "#959595"), font: .systemFont(ofSize: 12))
            genreContainer.addArrangedSubview(label)
        }

        let attributedString = NSMutableAttributedString(string: movie.userScore,
                                                         attributes: [NSAttributedString.Key.font:
                                                                        UIFont.systemFont(ofSize: 20, weight: .bold)])
        attributedString.append(NSAttributedString(string: " %",
                                                   attributes: [NSAttributedString.Key.font:
                                                                    UIFont.systemFont(ofSize: 12, weight: .bold),
                                                                NSAttributedString.Key.baselineOffset: 5]))
        scoreLabel.attributedText = attributedString
    }

    private func setupLayout() {
        let headerView = getHeaderView()
        let informationView = getInformationView()
        let buttonContainer = getButtonContainer()
        let overviewView = getOverviewView()

        backgroundColor = .white
        addSubview(headerImageView)
        addSubview(headerView)
        addSubview(favoriteButton)
        addSubview(posterImageView)
        addSubview(informationView)
        addSubview(buttonContainer)
        addSubview(overviewView)

        headerImageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalTo(headerView.snp.bottom)
        }

        headerView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(safeAreaLayoutGuide.snp.top)
            make.height.equalTo(243)
        }

        favoriteButton.snp.makeConstraints { make in
            make.bottom.equalTo(posterImageView.snp.top).offset(10)
            make.leading.equalTo(posterImageView.snp.trailing).offset(-4)
            make.height.width.equalTo(48)
        }

        posterImageView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom).offset(-44)
            make.leading.equalToSuperview().inset(37)
            make.height.equalTo(162)
            make.width.equalTo(120)
        }

        informationView.snp.makeConstraints { make in
            make.leading.equalTo(posterImageView.snp.trailing).offset(20)
            make.top.equalTo(headerView.snp.bottom)
            make.trailing.equalToSuperview().inset(37)
        }

        buttonContainer.snp.makeConstraints { make in
            make.top.equalTo(posterImageView.snp.bottom).offset(27)
            make.leading.trailing.equalToSuperview().inset(37)
            make.height.equalTo(56)
        }

        overviewView.snp.makeConstraints { make in
            make.top.equalTo(buttonContainer.snp.bottom).offset(34)
            make.leading.trailing.bottom.equalToSuperview().inset(37)
        }
    }

    private func getHeaderView() -> UIView {
        let headerView = UIView()
        headerView.addSubview(backButton)
        headerView.addSubview(headerLabel)

        backButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(34)
            make.top.equalToSuperview().inset(31)
        }

        headerLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(32)
            make.top.equalTo(backButton.snp.bottom).offset(18)
        }

        return headerView
    }

    private func getInformationView() -> UIView {
        let userScoreLabel = UILabel(text: "user score", textColor: .black, font: .systemFont(ofSize: 12))

        let container = UIView()
        container.addSubview(titleLabel)
        container.addSubview(releaseLabel)
        container.addSubview(genreContainer)
        container.addSubview(scoreLabel)
        container.addSubview(userScoreLabel)
        container.addSubview(scoreProgressView)

        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(6)
            make.leading.trailing.equalToSuperview()
        }

        releaseLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview()
        }

        genreContainer.snp.makeConstraints { make in
            make.top.equalTo(releaseLabel.snp.bottom)
            make.leading.equalToSuperview()
        }

        scoreLabel.snp.makeConstraints { make in
            make.top.equalTo(genreContainer.snp.bottom).offset(15)
            make.leading.equalToSuperview()
        }

        userScoreLabel.snp.makeConstraints { make in
            make.centerY.equalTo(scoreLabel.snp.centerY)
            make.leading.equalTo(scoreLabel.snp.trailing).offset(17)
        }

        scoreProgressView.snp.makeConstraints { make in
            make.top.equalTo(scoreLabel.snp.bottom).offset(3)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview().inset(50)
        }

        return container
    }

    private func getButtonContainer() -> UIView {
        let rateButton = rateButton.setShadow()
        let viewFavsButton = viewFavsButton.setShadow()

        let container = UIStackView()
        container.axis = .horizontal
        container.spacing = 10
        container.distribution = .fillEqually
        container.addArrangedSubview(rateButton)
        container.addArrangedSubview(viewFavsButton)

        return container
    }

    private func getOverviewView() -> UIView {
        let titleLabel = UILabel(text: "Overview", textColor: .black, font: .systemFont(ofSize: 16, weight: .bold))

        let container = UIStackView()
        container.axis = .vertical
        container.spacing = 14
        container.addArrangedSubview(titleLabel)
        container.addArrangedSubview(overviewTextView)

        return container
    }
}
