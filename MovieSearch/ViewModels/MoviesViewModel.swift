//
//  MoviesViewModel.swift
//  MovieSearch
//
//  Created by Shih-Han Hsu on 19/2/2024.
//

import Foundation
import Combine
import UIKit

class MoviesViewModel {

    var searchMovie = CurrentValueSubject<String, Never>("")
    @Published var movies: [MovieItem] = []
    private var cancellables = Set<AnyCancellable>()
    private var moviesIndex: [String: Int] = [:]

    init(movieDataStore: MovieDataStore) {
        ImageCacheManager.shared.cacheUpdatePublisher
            .sink { update in
                if let imageType = MovieImageType.from(id: update.id) {
                    let movieID = String(update.id.dropFirst(imageType.rawValue.count))
                    if let index = self.moviesIndex[movieID] {
                        var movieItem = self.movies[index]
                        switch imageType {
                        case .poster:
                            movieItem.image = update.image
                        case .backdrop:
                            movieItem.backdropImage = update.image
                        }
                        self.movies[index] = movieItem
                    }
                }
            }
            .store(in: &cancellables)

        searchMovie
            .removeDuplicates()
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .flatMap { searchText in
                Future<[MovieItem], Never> { promise in
                    Task {
                        do {
                            let moviesResponse: MoviesResponse
                            if searchText.isEmpty {
                                moviesResponse = try await TMDBService.shared.fetchPopularMovies()
                            } else {
                                moviesResponse = try await TMDBService.shared.searchMovies(keyword: searchText)
                            }
                            let movieItems = moviesResponse.results.map {
                                var image: UIImage? = nil
                                var backdropImage: UIImage? = nil
                                if let posterPath = $0.posterPath {
                                    image = ImageCacheManager.shared.loadImage(id: "poster" + String($0.id), from: posterPath)
                                }
                                if let backdropPath = $0.backdropPath {
                                    backdropImage = ImageCacheManager.shared.loadImage(id: "backdrop" + String($0.id), from: backdropPath)
                                }
                                return MovieItem(id: String($0.id),
                                                 backdropImage: backdropImage,
                                                 image: image,
                                                 title: $0.title,
                                                 releaseYear: String($0.releaseDate.prefix(4)),
                                                 userScore: ($0.voteAverage * 10).formatted(.number.precision(.fractionLength(0))),
                                                 genreList: $0.genreIds.compactMap { movieDataStore.genres[$0] },
                                                 genreIds: $0.genreIds,
                                                 overview: $0.overview,
                                                 myRating: movieDataStore.ratedMovies[String($0.id)])
                            }
                            self.updateMoviesIndex(movieItems: movieItems)
                            promise(.success(movieItems))
                        } catch {
                            // Error handling
                            print(error)
                            promise(.success([]))
                        }
                    }
                }
            }
            .receive(on: RunLoop.main)
            .assign(to: \.movies, on: self)
            .store(in: &cancellables)

        movieDataStore.$genres
            .removeDuplicates()
            .sink { [weak self] genres in
                guard let self = self else { return }
                self.movies = self.movies.map { MovieItem(id: $0.id,
                                                          backdropImage: $0.backdropImage,
                                                          image: $0.image,
                                                          title: $0.title,
                                                          releaseYear: $0.releaseYear,
                                                          userScore: $0.userScore,
                                                          genreList: $0.genreIds.compactMap { genres[$0] },
                                                          genreIds: $0.genreIds,
                                                          overview: $0.overview,
                                                          myRating: nil)
                }
            }.store(in: &cancellables)
    }

    private func updateMoviesIndex(movieItems: [MovieItem]) {
        moviesIndex = [:]
        for (index, movie) in movieItems.enumerated() {
            moviesIndex[movie.id] = index
        }
    }
}
