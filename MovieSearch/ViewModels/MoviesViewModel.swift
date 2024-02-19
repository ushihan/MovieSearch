//
//  MoviesViewModel.swift
//  MovieSearch
//
//  Created by Shih-Han Hsu on 19/2/2024.
//

import Foundation
import Combine

class MoviesViewModel {
    @Published var movies: [MovieItem] = []

    private var cancellables = Set<AnyCancellable>()

    func fetchPopularMovie() {
        TMDBService.shared.fetchPopularMovies { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let moviesResponse):
                    self?.movies = moviesResponse.results.map {
                        MovieItem(id: String($0.id),
                                  imageURL: "https://image.tmdb.org/t/p/w500/pWsD91G2R1Da3AKM3ymr3UoIfRb.jpg",
                                  title: $0.title,
                                  releaseYear: $0.releaseDate,
                                  userScore: String($0.voteAverage),
                                  genreList: $0.genreIds.map({ String($0) }) ) }

                case .failure(let error):
                    print(error.localizedDescription)
                    self?.movies = []
                }
            }
        }
    }
}
