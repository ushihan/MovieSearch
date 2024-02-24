//
//  RatingButton.swift
//  MovieSearch
//
//  Created by Shih-Han Hsu on 19/2/2024.
//

import Foundation
import UIKit

class RatingButton: UIButton {

    init() {
        super.init(frame: .zero)
        updateLayout(score: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        clipsToBounds = true
        layer.cornerRadius = 10
    }

    func updateLayout(score: Float?) {
        subviews.forEach { $0.removeFromSuperview() }

        let topLabel: UILabel
        let bottomLabel: UILabel

        if let score = score {
            let attributedString = NSMutableAttributedString(string: "You’ve rated this",
                                                             attributes: [NSAttributedString.Key.font:
                                                                            UIFont.setToInterReular(isBold: false, size: 11),
                                                                          NSAttributedString.Key.baselineOffset: 3])
            attributedString.append(NSAttributedString(string: " " + String(score),
                                                       attributes: [NSAttributedString.Key.font:
                                                                        UIFont.setToInterReular(isBold: false, size: 22)]))

            topLabel = UILabel()
            topLabel.textColor = .white
            topLabel.backgroundColor = UIColor(hex: "#6FAB3F")
            topLabel.textAlignment = .center
            topLabel.attributedText = attributedString

            bottomLabel = UILabel(text: "click to reset", textColor: UIColor(hex: "#6FAB3F"),
                                  font: .setToInterReular(isBold: false, size: 12), textAlignment: .center)
            bottomLabel.backgroundColor = .black
        } else {
            topLabel = UILabel(text: "Rate it myself >", textColor: .white,
                               font: .setToInterReular(isBold: false, size: 16), textAlignment: .center)
            topLabel.backgroundColor = UIColor(hex: "#AB803F")

            bottomLabel = UILabel(text: "add personal rating", textColor: UIColor(hex: "#D7BA8E"),
                                  font: .setToInterReular(isBold: false, size: 12), textAlignment: .center)
            bottomLabel.backgroundColor = .black
        }

        addSubview(topLabel)
        addSubview(bottomLabel)

        topLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalTo(self.snp.centerY)
        }

        bottomLabel.snp.makeConstraints { make in
            make.bottom.leading.trailing.equalToSuperview()
            make.top.equalTo(self.snp.centerY)
        }

        sendSubviewToBack(topLabel)
        sendSubviewToBack(bottomLabel)
    }
}
