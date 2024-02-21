//
//  Storage.swift
//  MovieSearch
//
//  Created by Shih-Han Hsu on 21/2/2024.
//

import Foundation

class MovieDataStore {

    @Published var favoriteMovies: [MovieItem] = []
    @Published var genres: [Int: String] = [:]

    init() {
        Task {
            do {
                let moviesResponse = try await TMDBService.shared.fetchMyFavorite()
                let movieItem = moviesResponse.results.map {
                    var imageURL: String? = nil
                    var backdropImageURL: String? = nil
                    if let posterPath = $0.posterPath {
                        imageURL = TMDBService.shared.fetchImageFullUrl(path: posterPath)
                    }
                    if let backdropPath = $0.backdropPath {
                        backdropImageURL = TMDBService.shared.fetchImageFullUrl(path: backdropPath)
                    }
                    return MovieItem(id: String($0.id),
                                    backdropImageURL: backdropImageURL,
                                    imageURL: imageURL,
                                    title: $0.title,
                                    releaseYear: String($0.releaseDate.prefix(4)),
                                    userScore: ($0.voteAverage * 10).formatted(.number.precision(.fractionLength(0))),
                                    genreList: $0.genreIds.compactMap { self.genres[$0] },
                                    overview: $0.overview,
                                    myRating: nil)
                }
                favoriteMovies = movieItem
            } catch {
                // Error handling
                print(error)
            }
        }

        Task {
            do {
                let resultResponse = try await TMDBService.shared.fetchMovieGenre()
                resultResponse.genres.forEach { genre in
                    genres[genre.id] = genre.name
                }
            } catch {
                // Error handling
                print(error)
            }
        }
    }

    func add(movie: MovieItem) {
        Task {
            do {
                let response = try await TMDBService.shared.setFavorite(movieId: movie.id, favorite: true)
                if response.code == MessageCode.add.rawValue {
                    favoriteMovies.append(movie)
                }
            } catch {
                // Error handling
                print(error)
            }
        }
    }

    func remove(movie: MovieItem) {
        Task {
            do {
                let response = try await TMDBService.shared.setFavorite(movieId: movie.id, favorite: false)
                if response.code == MessageCode.remove.rawValue {
                    favoriteMovies.removeAll { $0.id == movie.id }
                }
            } catch {
                // Error handling
                print(error)
            }
        }
    }
}
