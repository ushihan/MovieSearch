//
//  FavoriteViewModel.swift
//  MovieSearch
//
//  Created by Shih-Han Hsu on 21/2/2024.
//

import Foundation
import Combine

class FavoriteViewModel {

    @Published var movies: [MovieItem] = []
    private var cancellables = Set<AnyCancellable>()
    private let movieDataStore: MovieDataStore

    init(movieDataStore: MovieDataStore) {
        self.movieDataStore = movieDataStore

        movieDataStore.$favoriteMovies
            .combineLatest(movieDataStore.$ratedMovies)
            .sink { [weak self] movies, ratedMovies in
                self?.movies = movies.map {
                    var movie = $0
                    movie.myRating = ratedMovies[$0.id]
                    return movie
                }
            }.store(in: &cancellables)
    }

    func setFavorite(movie: MovieItem, favorite: Bool) {
        if favorite {
            movieDataStore.addToFavorite(movie: movie)
        } else {
            movieDataStore.removeFromFavorite(movie: movie)
        }
    }
}
