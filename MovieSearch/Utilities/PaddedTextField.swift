//
//  PaddedTextField.swift
//  MovieSearch
//
//  Created by Shih-Han Hsu on 18/2/2024.
//

import Foundation
import UIKit

class PaddedTextField: UITextField {

    private var textInsets: UIEdgeInsets

    init(textInsets: UIEdgeInsets) {
        self.textInsets = textInsets
        super.init(frame: .zero)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.bounds.height / 2
        self.layer.masksToBounds = true
    }

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textInsets)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textInsets)
    }

    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textInsets)
    }
}
