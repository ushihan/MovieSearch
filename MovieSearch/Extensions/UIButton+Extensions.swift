//
//  UIButton+Extension.swift
//  MovieSearch
//
//  Created by Shih-Han Hsu on 19/2/2024.
//

import Foundation
import UIKit

extension UIButton {

    func setShadow() -> UIView {
        let shadow = UIView()
        shadow.backgroundColor = .clear
        shadow.layer.shadowColor = UIColor.black.cgColor
        shadow.layer.shadowOffset = CGSize(width: 0, height: 2)
        shadow.layer.shadowOpacity = 0.5
        shadow.layer.shadowRadius = 4

        shadow.addSubview(self)
        self.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }

        return shadow
    }
}
