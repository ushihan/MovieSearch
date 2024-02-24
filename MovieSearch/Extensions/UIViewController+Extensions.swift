//
//  UIViewController+Extension.swift
//  MovieSearch
//
//  Created by Shih-Han Hsu on 24/2/2024.
//

import Foundation
import UIKit

extension UIViewController {

    func showErrorAlert(message: String) {
        DispatchQueue.main.async {
            let errorAlertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default)
            errorAlertController.addAction(okAction)
            self.present(errorAlertController, animated: true)
        }
    }
}
