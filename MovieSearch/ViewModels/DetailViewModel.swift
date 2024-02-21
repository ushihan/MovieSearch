//
//  DetailViewModel.swift
//  MovieSearch
//
//  Created by Shih-Han Hsu on 21/2/2024.
//

import Foundation
import Combine

class DetailViewModel {

    var movie: MovieItem
    @Published var isFavorite: Bool = false
    private var cancellables = Set<AnyCancellable>()
    private let movieDataStore: MovieDataStore

    init(with movie: MovieItem, movieDataStore: MovieDataStore) {
        self.movie = movie
        self.movieDataStore = movieDataStore

        movieDataStore.$favoriteMovies
            .receive(on: RunLoop.main)
            .sink { [weak self] movies in
                self?.isFavorite = movies.contains { $0.id == self?.movie.id }
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
