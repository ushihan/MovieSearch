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
    @Published var genres: [Int: String] = [:]
    private var cancellables = Set<AnyCancellable>()

    init() {
        ImageCacheManager.shared.cacheUpdatePublisher
            .sink { update in
                self.favoriteMovies = self.favoriteMovies.map({ movieItem in
                    var movieItem = movieItem
                    if update.id == "logo" + movieItem.id {
                        movieItem.image = update.image
                    } else if update.id == "backdrop" + movieItem.id {
                        movieItem.backdropImage = update.image
                    }
                    return movieItem
                })
            }
            .store(in: &cancellables)

        Task {
            do {
                let moviesResponse = try await TMDBService.shared.fetchMyFavorite()
                let movieItem = moviesResponse.results.map {
                    var image: UIImage? = nil
                    var backdropImage: UIImage? = nil
                    if let posterPath = $0.posterPath {
                        image = ImageCacheManager.shared.loadImage(id: "logo" + String($0.id), from: posterPath)
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
