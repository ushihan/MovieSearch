//
//  MoviesViewModel.swift
//  MovieSearch
//
//  Created by Shih-Han Hsu on 19/2/2024.
//

import Foundation
import Combine

class MoviesViewModel {

    var searchMovie = CurrentValueSubject<String, Never>("")
    @Published var movies: [MovieItem] = []
    private var cancellables = Set<AnyCancellable>()

    init(movieDataStore: MovieDataStore) {
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
                            let movieItem = moviesResponse.results.map {
                                var backdropImageURL: String? = nil
                                var imageURL: String? = nil
                                if let backdropPath = $0.backdropPath {
                                    backdropImageURL = TMDBService.shared.fetchImageFullUrl(path: backdropPath)
                                }
                                if let posterPath = $0.posterPath {
                                    imageURL = TMDBService.shared.fetchImageFullUrl(path: posterPath)
                                }
                                return MovieItem(id: String($0.id),
                                                 backdropImageURL: backdropImageURL,
                                                 imageURL: imageURL,
                                                 title: $0.title,
                                                 releaseYear: String($0.releaseDate.prefix(4)),
                                                 userScore: ($0.voteAverage * 10).formatted(.number.precision(.fractionLength(0))),
                                                 genreList: $0.genreIds.map { movieDataStore.genres[$0] ?? String($0) },
                                                 overview: $0.overview,
                                                 myRating: nil)
                            }
                            promise(.success(movieItem))
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
            .receive(on: RunLoop.main)
            .sink { [weak self] genres in
                guard let self = self else { return }
                self.movies = self.movies.map { MovieItem(id: $0.id,
                                                          backdropImageURL: $0.backdropImageURL,
                                                          imageURL: $0.imageURL,
                                                          title: $0.title,
                                                          releaseYear: $0.releaseYear,
                                                          userScore: $0.userScore,
                                                          genreList: $0.genreList.compactMap { genres[Int($0)!] },
                                                          overview: $0.overview,
                                                          myRating: nil)
                }
            }.store(in: &cancellables)
    }
}
