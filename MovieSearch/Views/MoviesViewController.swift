//
//  MovieViewController.swift
//  MovieSearch
//
//  Created by Shih-Han Hsu on 18/2/2024.
//

import UIKit
import SnapKit

class MoviesViewController: UIViewController {

    private var dataSource: UITableViewDiffableDataSource<MoviewSection, MovieItem>!

    private var moviesTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(MovieCell.self, forCellReuseIdentifier: "movieCell")
        tableView.rowHeight = 151
        tableView.separatorStyle = .none
        return tableView
    }()

    private lazy var titleLabel: UILabel = {
        return UILabel(textColor: UIColor(hex: "#347868"), font: .preferredFont(forTextStyle: .largeTitle))
    }()

    private lazy var searchTextField: PaddedTextField = {
        let textField = PaddedTextField(textInsets: UIEdgeInsets(top: 12, left: 27, bottom: 12, right: 27))
        textField.placeholder = "Search"
        textField.font = .systemFont(ofSize: 16, weight: .bold)
        textField.backgroundColor = .white
        textField.textColor = .black
        textField.borderStyle = .none
        textField.returnKeyType = .search
        textField.clearButtonMode = .unlessEditing
        return textField
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        setTableView()
        searchTextField.delegate = self
    }

    private func setTableView() {
        moviesTableView.delegate = self

        dataSource = UITableViewDiffableDataSource<MoviewSection, MovieItem>(tableView: moviesTableView) { (tableView, indexPath, item) -> UITableViewCell? in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell",
                                                           for: indexPath) as? MovieCell else {
                return UITableViewCell()
            }
            cell.configure(with: item)
            return cell
        }

        var snapshot = NSDiffableDataSourceSnapshot<MoviewSection, MovieItem>()
        snapshot.appendSections([.main])
        snapshot.appendItems([MovieItem(id: "000",
                                        imageURL: "https://image.tmdb.org/t/p/w500/pWsD91G2R1Da3AKM3ymr3UoIfRb.jpg",
                                        title: "Five Nights at Freddys", releaseYear: "2023",
                                        userScore: "70", genreList: ["Animation", "Family"]),
                              MovieItem(id: "111",
                                        imageURL: "https://image.tmdb.org/t/p/w500/pWsD91G2R1Da3AKM3ymr3UoIfRb.jpg",
                                        title: "Five Nights at Freddys", releaseYear: "2023",
                                        userScore: "70", genreList: ["Animation", "Family"])])
        dataSource.apply(snapshot, animatingDifferences: true)
    }

    // MARK: - set up layout

    private func setLayout() {
        let headerView = getHeaderView()

        view.backgroundColor = UIColor(hex: "#8EEAA2")
        view.addSubview(headerView)
        view.addSubview(moviesTableView)

        headerView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
        }

        moviesTableView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom)
            make.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview()
        }
    }

    private func getHeaderView() -> UIView {
        titleLabel.text = "Popular Right now"

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
}

// MARK: - UITableViewDelegate
extension MoviesViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let imageURL = "https://image.tmdb.org/t/p/w500/pWsD91G2R1Da3AKM3ymr3UoIfRb.jpg"
        let overview = "A magical meteor crash-lands in Adventure City, gives the PAW Patrol pups superpowers,and transforms them into The Mighty Pups. When the Patrol's archrival Humdinger breaks out of jail and teams up with mad scientist Victoria Vance to steal the powers for themselves, the Mighty Pups must save Adventure City and stop the supervillains before it's too late."
        let detailModel = MovieDetailModel(title: "Paw Patrol",
                                           headerImageURL: imageURL,
                                           posterImageURL: imageURL,
                                           releaseYear: "2023",
                                           userScore: "70",
                                           genreList: ["Animation", "Family"],
                                           overview: overview)
        let movieDetailViewController = MovieDetailViewController(model: detailModel)
        movieDetailViewController.modalPresentationStyle = .fullScreen
        movieDetailViewController.modalTransitionStyle = .coverVertical
        self.present(movieDetailViewController, animated: true)
    }
}

// MARK: - UITextFieldDelegate
extension MoviesViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // call search API
        textField.resignFirstResponder()
        return true
    }
}
