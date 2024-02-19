//
//  RoundImageView.swift
//  MovieSearch
//
//  Created by Shih-Han Hsu on 19/2/2024.
//

import Foundation
import UIKit

class RoundImageView: UIImageView {

    private let corners: UIRectCorner
    private let borderWidth: CGFloat
    private let borderColor: UIColor

    init(roundingCorners: UIRectCorner, borderWidth: CGFloat = 0, borderColor: UIColor = .white) {
        self.corners = roundingCorners
        self.borderWidth = borderWidth
        self.borderColor = borderColor
        super.init(frame: .zero)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners,
                                cornerRadii: CGSize(width: 30, height: 30))
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        layer.mask = maskLayer

        let borderLayer = CAShapeLayer()
        borderLayer.path = maskLayer.path
        borderLayer.lineWidth = borderWidth
        borderLayer.strokeColor = borderColor.cgColor
        borderLayer.fillColor =  UIColor.clear.cgColor
        borderLayer.frame = bounds
        layer.addSublayer(borderLayer)
    }
}
