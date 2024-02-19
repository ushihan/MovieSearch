//
//  MovieDetailView.swift
//  MovieSearch
//
//  Created by Shih-Han Hsu on 19/2/2024.
//

import Foundation
import UIKit

class MovieDetailView: UIView {

    private var detailModel: MovieItem

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
        return TwoPartButton(model: buttonStyleModel)
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

    init(detailModel: MovieItem) {
        self.detailModel = detailModel
        super.init(frame: .zero)
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLayout() {
        let headerImageView = getHeaderImageView()
        let headerView = getHeaderView()
        let detailView = getDetailView()

        backgroundColor = .white
        addSubview(headerImageView)
        addSubview(headerView)
        addSubview(detailView)

        headerImageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalTo(headerView.snp.bottom)
        }

        headerView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(safeAreaLayoutGuide.snp.top)
            make.height.equalTo(243)
        }

        detailView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(37)
            make.top.equalTo(headerView.snp.bottom)
            make.bottom.equalToSuperview()
        }
    }

    private func getHeaderImageView() -> UIView {
        let imageView = UIImageView()
        imageView.loadImage(from: detailModel.imageURL)
        imageView.contentMode = .scaleAspectFill
        let maskView = UIView()
        maskView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        maskView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        imageView.addSubview(maskView)

        return imageView
    }

    private func getHeaderView() -> UIView {
        let titleLabel = UILabel(text: detailModel.title, textColor: .white,
                                 font: .preferredFont(forTextStyle: .largeTitle))

        let headerView = UIView()
        headerView.addSubview(backButton)
        headerView.addSubview(titleLabel)

        backButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(34)
            make.top.equalToSuperview().inset(31)
        }

        titleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(32)
            make.top.equalTo(backButton.snp.bottom).offset(18)
        }

        return headerView
    }

    private func getDetailView() -> UIView {
        let posterImageView = RoundImageView(roundingCorners: [.topRight], borderWidth: 5)
        posterImageView.loadImage(from: detailModel.imageURL)
        posterImageView.contentMode = .scaleAspectFill

        let informationView = getInformationView()
        let buttonContainer = getButtonContainer()
        let overviewView = getOverviewView()

        let container = UIView()
        container.addSubview(favoriteButton)
        container.addSubview(posterImageView)
        container.addSubview(informationView)
        container.addSubview(buttonContainer)
        container.addSubview(overviewView)

        favoriteButton.snp.makeConstraints { make in
            make.bottom.equalTo(posterImageView.snp.top).offset(10)
            make.leading.equalTo(posterImageView.snp.trailing).offset(-4)
            make.height.width.equalTo(48)
        }

        posterImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(-44)
            make.leading.equalToSuperview()
            make.height.equalTo(162)
            make.width.equalTo(120)
        }

        informationView.snp.makeConstraints { make in
            make.leading.equalTo(posterImageView.snp.trailing).offset(20)
            make.top.trailing.equalToSuperview()
        }

        buttonContainer.snp.makeConstraints { make in
            make.top.equalTo(posterImageView.snp.bottom).offset(27)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(56)
        }

        overviewView.snp.makeConstraints { make in
            make.top.equalTo(buttonContainer.snp.bottom).offset(34)
            make.leading.trailing.bottom.equalToSuperview()
        }

        return container
    }

    private func getInformationView() -> UIView {
        let titleLabel = UILabel(text: detailModel.title, textColor: .black,
                                 font: .systemFont(ofSize: 16, weight: .bold))
        let releaseLabel = UILabel(text: detailModel.releaseYear, textColor: UIColor(hex: "#959595"),
                                   font: .systemFont(ofSize: 12))
        let genreContainer = getGenreContainer()
        let scoreLabel = getScoreLabel()
        let userScoreLabel = UILabel(text: "user score", textColor: .black, font: .systemFont(ofSize: 12))

        let scoreProgressView = UIProgressView(progressViewStyle: .default)
        scoreProgressView.progress = (Float(detailModel.userScore) ?? 0) / 100
        scoreProgressView.progressTintColor = UIColor(hex: "#4CAB4A")

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

    private func getGenreContainer() -> UIView {
        let container = UIStackView()
        container.axis = .horizontal
        container.spacing = 8
        detailModel.genreList.forEach { genre in
            let label = UILabel(text: genre, textColor: UIColor(hex: "#959595"), font: .systemFont(ofSize: 12))
            container.addArrangedSubview(label)
        }
        return container
    }

    private func getScoreLabel() -> UILabel {
        let label = UILabel()
        let attributedString = NSMutableAttributedString(string: detailModel.userScore,
                                                         attributes: [NSAttributedString.Key.font:
                                                                        UIFont.systemFont(ofSize: 20, weight: .bold)])
        attributedString.append(NSAttributedString(string: " %",
                                                   attributes: [NSAttributedString.Key.font:
                                                                    UIFont.systemFont(ofSize: 12, weight: .bold),
                                                                NSAttributedString.Key.baselineOffset: 5]))
        label.attributedText = attributedString
        return label
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
        let overviewLabel = UILabel(text: detailModel.overview, textColor: .black, font: .systemFont(ofSize: 16))
        overviewLabel.numberOfLines = 0

        let overviewTextView = UITextView()
        overviewTextView.text = detailModel.overview
        overviewTextView.font = .systemFont(ofSize: 16)
        overviewTextView.textColor = .black
        overviewTextView.isEditable = false
        overviewTextView.isScrollEnabled = true

        let container = UIStackView()
        container.axis = .vertical
        container.spacing = 14
        container.addArrangedSubview(titleLabel)
        container.addArrangedSubview(overviewTextView)

        return container
    }
}
