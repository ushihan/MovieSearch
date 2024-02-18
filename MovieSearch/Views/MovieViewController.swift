//
//  MovieViewController.swift
//  MovieSearch
//
//  Created by Shih-Han Hsu on 18/2/2024.
//

import UIKit
import SnapKit

class MovieViewController: UIViewController {

    private var dataSource: UITableViewDiffableDataSource<MoviewSection, MovieItem>!

    private var moviesTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(MovieCell.self, forCellReuseIdentifier: "movieCell")
        tableView.rowHeight = 151
        tableView.separatorStyle = .none
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()

        dataSource = UITableViewDiffableDataSource<MoviewSection, MovieItem>(tableView: moviesTableView) {
            (tableView, indexPath, item) -> UITableViewCell? in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell", for: indexPath) as? MovieCell else {
                return UITableViewCell()
            }
            cell.configure(with: item)
            return cell
        }

        var snapshot = NSDiffableDataSourceSnapshot<MoviewSection, MovieItem>()
        snapshot.appendSections([.main])
        snapshot.appendItems([MovieItem(id: "000", imageURL: "https://image.tmdb.org/t/p/w500/pWsD91G2R1Da3AKM3ymr3UoIfRb.jpg", title: "Five Nights at Freddys", releaseYear: "2023", userScore: "70", genreList: ["Animation", "Family"]),
                              MovieItem(id: "111", imageURL: "https://image.tmdb.org/t/p/w500/pWsD91G2R1Da3AKM3ymr3UoIfRb.jpg", title: "Five Nights at Freddys", releaseYear: "2023", userScore: "70", genreList: ["Animation", "Family"])])
        dataSource.apply(snapshot, animatingDifferences: true)
    }

    func setLayout() {
        view.backgroundColor = .white
        view.addSubview(moviesTableView)

        moviesTableView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(10)
        }
    }
}
