//
//  DetailViewModel.swift
//  MovieSearch
//
//  Created by Shih-Han Hsu on 21/2/2024.
//

import Foundation
import Combine

class DetailViewModel {

    @Published var movie: MovieItem
    @Published var isFavorite: Bool = false
    private var cancellables = Set<AnyCancellable>()
    private let movieDataStore: MovieDataStore

    init(with movie: MovieItem, movieDataStore: MovieDataStore) {
        self.movie = movie
        self.movieDataStore = movieDataStore

        ImageCacheManager.shared.cacheUpdatePublisher
            .sink { update in
                guard MovieImageType.getOriginalId(id: update.id) == self.movie.id else { return }
                if let imageType = MovieImageType.from(id: update.id) {
                    var movieItem = self.movie
                    switch imageType {
                    case .poster:
                        movieItem.image = update.image
                    case .backdrop:
                        movieItem.backdropImage = update.image
                    }
                    self.movie = movieItem
                }
            }
            .store(in: &cancellables)

        movieDataStore.$favoriteMovies
            .combineLatest(movieDataStore.$ratedMovies)
            .receive(on: RunLoop.main)
            .sink { [weak self] favoriteMovies, ratedMovies in
                if let movieId = self?.movie.id {
                    self?.isFavorite = favoriteMovies.contains { $0.id == movieId }
                    self?.movie.myRating = ratedMovies[movieId]
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

    func setRating(score: Float, errorHandle: @escaping ((String) -> Void), completion: @escaping (() -> Void)) {
        movieDataStore.rate(movieId: movie.id, score: score, errorHandle: errorHandle, completion: completion)
    }

    func resetRating() {
        movieDataStore.resetRating(movieId: movie.id)
    }
}
