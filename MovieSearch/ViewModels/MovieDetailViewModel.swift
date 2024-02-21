//
//  MovieDetailViewModel.swift
//  MovieSearch
//
//  Created by Shih-Han Hsu on 21/2/2024.
//

import Foundation

class MovieDetailViewModel {

    init() {
        Task {
            do {
                let moviesResponse = try await TMDBService.shared.getMyFavorite()
                moviesResponse.results.forEach {
                    var imageURL: String? = nil
                    if let posterPath = $0.posterPath {
                        imageURL = TMDBService.shared.fetchImageFullUrl(path: posterPath)
                    }
                    let item = FavoriteItem(id: String($0.id), imageURL: imageURL, score: "0")
                    FavoriteCache.shared.append(movie: item)
                }
            } catch {
                // Error handling
                print(error)
            }
        }
    }
}
