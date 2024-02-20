//
//  TwoPartButton.swift
//  MovieSearch
//
//  Created by Shih-Han Hsu on 19/2/2024.
//

import Foundation
import UIKit

struct TwoPartStyleModel {
    let topColor: UIColor
    let topText: String
    let topTextColor: UIColor
    let topFont: UIFont
    let bottomColor: UIColor
    let bottomText: String
    let bottomTextColor: UIColor
    let bottomFont: UIFont
}

class TwoPartButton: UIButton {

    init(style: TwoPartStyleModel) {
        super.init(frame: .zero)
        setupLayout(style: style)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        clipsToBounds = true
        layer.cornerRadius = 10
    }

    private func setupLayout(style: TwoPartStyleModel) {
        let topView = UILabel(text: style.topText, textColor: style.topTextColor,
                              font: style.topFont, textAlignment: .center)
        topView.backgroundColor = style.topColor

        let bottomView = UILabel(text: style.bottomText, textColor: style.bottomTextColor,
                                 font: style.bottomFont, textAlignment: .center)
        bottomView.backgroundColor = style.bottomColor

        addSubview(topView)
        addSubview(bottomView)

        topView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalTo(self.snp.centerY)
        }

        bottomView.snp.makeConstraints { make in
            make.bottom.leading.trailing.equalToSuperview()
            make.top.equalTo(self.snp.centerY)
        }

        sendSubviewToBack(topView)
        sendSubviewToBack(bottomView)
    }
}
