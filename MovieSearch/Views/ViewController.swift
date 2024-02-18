//
//  ViewController.swift
//  MovieSearch
//
//  Created by Shih-Han Hsu on 18/2/2024.
//

import UIKit

class ViewController: UIViewController {

    lazy private var demoLabel: UILabel = {
        let label = UILabel()
        label.text = "hello world!"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .green
        setLayout()
    }

    func setLayout() {
        view.addSubview(self.demoLabel)

        let labelConstraints = [
            self.demoLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.demoLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        ]
        NSLayoutConstraint.activate(labelConstraints)
    }
}

