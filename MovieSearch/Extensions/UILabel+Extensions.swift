//
//  UILabel+Extension.swift
//  MovieSearch
//
//  Created by Shih-Han Hsu on 19/2/2024.
//

import Foundation
import UIKit

extension UILabel {

    convenience init(frame: CGRect = .zero, text: String = "", textColor: UIColor,
                     font: UIFont, textAlignment: NSTextAlignment = .left) {
        self.init(frame: frame)
        self.text = text
        self.font = font
        self.textColor = textColor
        self.textAlignment = textAlignment
    }
}
