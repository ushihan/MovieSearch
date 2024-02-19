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

    init(model: TwoPartStyleModel) {
        super.init(frame: .zero)
        setupLayout(model: model)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        clipsToBounds = true
        layer.cornerRadius = 10
    }

    private func setupLayout(model: TwoPartStyleModel) {
        let topView = UILabel(text: model.topText, textColor: model.topTextColor,
                              font: model.topFont, textAlignment: .center)
        topView.backgroundColor = model.topColor

        let bottomView = UILabel(text: model.bottomText, textColor: model.bottomTextColor,
                                 font: model.bottomFont, textAlignment: .center)
        bottomView.backgroundColor = model.bottomColor

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
