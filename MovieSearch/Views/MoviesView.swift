//
//  MoviesView.swift
//  MovieSearch
//
//  Created by Shih-Han Hsu on 19/2/2024.
//

import Foundation
import UIKit

class MoviesView: UIView {

    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.rowHeight = 151
        tableView.separatorStyle = .none
        return tableView
    }()

    let searchTextField: PaddedTextField = {
        let textField = PaddedTextField(textInsets: UIEdgeInsets(top: 12, left: 27, bottom: 12, right: 27))
        textField.placeholder = "Search"
        textField.font = .setToInterReular(isBold: true, size: 16)
        textField.backgroundColor = .white
        textField.textColor = .black
        textField.borderStyle = .none
        textField.returnKeyType = .search
        textField.clearButtonMode = .unlessEditing
        return textField
    }()

    private var titleLabel: UILabel = {
        let label = UILabel(text: "Popular Right now", textColor: UIColor(hex: "#347868"), font: .setToJomhuria(size: 60))
        label.adjustsFontSizeToFitWidth = true
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLayout() {
        let headerView = getHeaderView()

        backgroundColor = UIColor(hex: "#8EEAA2")
        addSubview(headerView)
        addSubview(tableView)

        headerView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(safeAreaLayoutGuide.snp.top)
        }

        tableView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom)
            make.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview()
        }
    }

    private func getHeaderView() -> UIView {
        let headerView = UIView()
        headerView.addSubview(searchTextField)
        headerView.addSubview(titleLabel)

        searchTextField.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(37)
            make.top.equalToSuperview().inset(57)
        }

        titleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(37)
            make.top.equalTo(searchTextField.snp.bottom).offset(43)
            make.bottom.equalToSuperview().inset(21)
        }

        return headerView
    }

    func setTitle(text: String) {
        titleLabel.text = text
    }
}
