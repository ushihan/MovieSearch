//
//  FavoriteCache.swift
//  MovieSearch
//
//  Created by Shih-Han Hsu on 21/2/2024.
//

import Foundation

class FavoriteCache {

    static let shared = FavoriteCache()
    private var favoriteMovies: [FavoriteItem] = []

    func append(movie: FavoriteItem) {
        favoriteMovies.append(movie)
    }

    func get() -> [FavoriteItem] {
        return favoriteMovies
    }
}
