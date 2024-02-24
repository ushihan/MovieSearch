//
//  Storage.swift
//  MovieSearch
//
//  Created by Shih-Han Hsu on 21/2/2024.
//

import Foundation
import UIKit
import Combine

class MovieDataStore {
    
    @Published var favoriteMovies: [MovieItem] = []
    @Published var ratedMovies: [String: Float] = [:]
    @Published var genres: [Int: String] = [:]
    private var cancellables = Set<AnyCancellable>()
    private var moviesIndex: [String: Int] = [:]

    init() {
        ImageCacheManager.shared.cacheUpdatePublisher
            .sink { update in
                if let imageType = MovieImageType.from(id: update.id) {
                    let movieID = String(update.id.dropFirst(imageType.rawValue.count))
                    if let index = self.moviesIndex[movieID] {
                        var movieItem = self.favoriteMovies[index]
                        switch imageType {
                        case .poster:
                            movieItem.image = update.image
                        case .backdrop:
                            movieItem.backdropImage = update.image
                        }
                        self.favoriteMovies[index] = movieItem
                    }
                }
            }
            .store(in: &cancellables)

        Task {
            do {
                let moviesResponse = try await TMDBService.shared.fetchMyFavorite()
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
                                     genreList: $0.genreIds.compactMap { self.genres[$0] },
                                     genreIds: $0.genreIds,
                                     overview: $0.overview,
                                     myRating: self.ratedMovies[String($0.id)])
                }
                favoriteMovies = movieItems
                self.updateMoviesIndex(movieItems: movieItems)
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

        Task {
            do {
                let moviesResponse = try await TMDBService.shared.fetchRatedMovies()
                let movieItems = moviesResponse.results.reduce(into: [String: Float]()) { (dict, movie) in
                    if let rating = movie.rating {
                        dict[String(movie.id)] = rating
                    }
                }
                ratedMovies = movieItems
            } catch {
                // Error handling
                print(error)
            }
        }
    }
    
    func addToFavorite(movie: MovieItem) {
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
    
    func removeFromFavorite(movie: MovieItem) {
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

    func rate(movieId: String, score: Float, errorHandle: @escaping ((String) -> Void), completion: (() -> Void)?) {
        Task {
            do {
                let response = try await TMDBService.shared.addRating(movieId: movieId, score: score)
                if response.code == MessageCode.add.rawValue || response.code == MessageCode.updated.rawValue {
                    ratedMovies[movieId] = score
                    completion?()
                } else {
                    errorHandle(response.message)
                }
            } catch {
                // Error handling
                print(error)
            }
        }
    }

    func resetRating(movieId: String) {
        Task {
            do {
                let response = try await TMDBService.shared.resetRating(movieId: movieId)
                if response.code == MessageCode.remove.rawValue {
                    ratedMovies.removeValue(forKey: movieId)
                }
            } catch {
                // Error handling
                print(error)
            }
        }
    }

    private func updateMoviesIndex(movieItems: [MovieItem]) {
        moviesIndex = [:]
        for (index, movie) in movieItems.enumerated() {
            moviesIndex[movie.id] = index
        }
    }
}
