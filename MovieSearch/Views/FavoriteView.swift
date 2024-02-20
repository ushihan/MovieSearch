//
//  FavoriteView.swift
//  MovieSearch
//
//  Created by Shih-Han Hsu on 20/2/2024.
//

import Foundation
import UIKit

class FavoriteView: UIView {
    
    let backButton: UIButton = {
        var config = UIButton.Configuration.filled()
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 10)
        config.image = UIImage(systemName: "chevron.backward",
                               withConfiguration: imageConfig)?.withTintColor(UIColor(hex: "#995630"), renderingMode: .alwaysOriginal)
        config.background.backgroundColor = .white.withAlphaComponent(0.3)
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.black,
            .font: UIFont.systemFont(ofSize: 10)
        ]
        config.attributedTitle = AttributedString("Back", attributes: AttributeContainer(attributes))
        config.imagePadding = 10
        config.contentInsets = NSDirectionalEdgeInsets(top: 7, leading: 24, bottom: 7, trailing: 24)

        let button = RoundButton()
        button.configuration = config

        return button
    }()

    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 120, height: 245)
        layout.minimumLineSpacing = 33
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()

    let searchButton: UIButton = {
        let button = RoundButton()
        var config = UIButton.Configuration.filled()
        config.background.backgroundColor = UIColor(hex: "#EFEFEF")
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.black,
            .font: UIFont.systemFont(ofSize: 16)
        ]
        config.attributedTitle = AttributedString("Search for More", attributes: AttributeContainer(attributes))
        button.configuration = config

        return button
    }()

    init() {
        super.init(frame: .zero)
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLayout() {
        backgroundColor = UIColor.white

        let topView = UIView()
        topView.backgroundColor = UIColor(hex: "#8EEAA2")

        let titleLabel = UILabel(text: "My favourites", textColor: UIColor(hex: "#347868"),
                                 font: .preferredFont(forTextStyle: .largeTitle))
        let searchButton = searchButton.setShadow()

        addSubview(topView)
        addSubview(backButton)
        addSubview(titleLabel)
        addSubview(collectionView)
        addSubview(searchButton)

        topView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalTo(backButton.snp.bottom).offset(27)
        }

        backButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(34)
            make.top.equalTo(safeAreaLayoutGuide.snp.top).inset(31)
        }

        titleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(35)
            make.top.equalTo(topView.snp.bottom).offset(35)
        }

        collectionView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(26)
            make.trailing.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(35)
            make.height.equalTo(250)
        }

        searchButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(99)
            make.leading.trailing.equalToSuperview().inset(50)
            make.height.equalTo(56)
        }
    }
}
