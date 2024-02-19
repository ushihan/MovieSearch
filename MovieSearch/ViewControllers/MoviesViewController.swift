//
//  MovieViewController.swift
//  MovieSearch
//
//  Created by Shih-Han Hsu on 18/2/2024.
//

import UIKit
import SnapKit
import Combine

class MoviesViewController: UIViewController {

    weak var coordinator: AppCoordinator?
    private let viewModel: MoviesViewModel
    private var cancellables = Set<AnyCancellable>()

    private var customView: MoviesView {
        guard let view = view as? MoviesView else {
            fatalError("view should be MoviesView")
        }
        return view
    }

    private var dataSource: UITableViewDiffableDataSource<MoviewSection, MovieItem>!

    init(viewModel: MoviesViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = MoviesView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
        customView.searchTextField.delegate = self

        viewModel.fetchPopularMovie()
    }

    private func setTableView() {
        customView.tableView.register(MovieCell.self, forCellReuseIdentifier: "movieCell")
        customView.tableView.delegate = self

        dataSource = UITableViewDiffableDataSource<MoviewSection, MovieItem>(tableView: customView.tableView) { (tableView, indexPath, item) -> UITableViewCell? in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell",
                                                           for: indexPath) as? MovieCell else {
                return UITableViewCell()
            }
            cell.configure(with: item)
            return cell
        }

        viewModel.$movies
            .receive(on: RunLoop.main)
            .sink { [weak self] movies in
                var snapshot = NSDiffableDataSourceSnapshot<MoviewSection, MovieItem>()
                snapshot.appendSections([.main])
                snapshot.appendItems(movies)
                self?.dataSource.apply(snapshot, animatingDifferences: true)
            }
            .store(in: &cancellables)
    }
}

// MARK: - UITableViewDelegate
extension MoviesViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        guard let selectedMovie = dataSource.itemIdentifier(for: indexPath) else { return }
        coordinator?.navigateToDetail(model: selectedMovie)
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