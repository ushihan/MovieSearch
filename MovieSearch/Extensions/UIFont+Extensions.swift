//
//  UIFont+Extensions.swift
//  MovieSearch
//
//  Created by Shih-Han Hsu on 22/2/2024.
//

import Foundation
import UIKit

extension UIFont {

    static func setToInterReular(isBold: Bool, size: CGFloat) -> UIFont {
        if isBold {
            return UIFont(name: "Inter-Regular_Bold", size: size) ?? .systemFont(ofSize: size, weight: isBold ? .bold : .regular)
        } else {
          return UIFont(name: "Inter-Regular", size: size) ?? .systemFont(ofSize: size, weight: isBold ? .bold : .regular)
        }
    }

    static func setToJomhuria(size: CGFloat) -> UIFont {
        return UIFont(name: "Jomhuria-Regular", size: size) ?? .systemFont(ofSize: size)
    }
}
