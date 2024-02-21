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
            .sink { [weak self] movies in
                self?.movies = movies
            }.store(in: &cancellables)
    }

    func setFavorite(movie: MovieItem, favorite: Bool) {
        if favorite {
            movieDataStore.add(movie: movie)
        } else {
            movieDataStore.remove(movie: movie)
        }
    }
}
