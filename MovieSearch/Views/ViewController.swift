//
//  ViewController.swift
//  MovieSearch
//
//  Created by Shih-Han Hsu on 18/2/2024.
//

import UIKit
import SnapKit

class ViewController: UIViewController {

    lazy private var demoLabel: UILabel = {
        let label = UILabel()
        label.text = "hello world!"
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .green
        setLayout()
    }

    func setLayout() {
        view.addSubview(demoLabel)

        demoLabel.snp.makeConstraints { make in
            make.center.equalTo(self.view)
        }
    }
}

