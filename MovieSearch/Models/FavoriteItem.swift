//
//  FavoriteItem.swift
//  MovieSearch
//
//  Created by Shih-Han Hsu on 20/2/2024.
//

import Foundation

enum FavoriteSection {
    case main
}

struct FavoriteItem: Hashable {
    let id: String
    let imageURL: String?
    let score: String
}
