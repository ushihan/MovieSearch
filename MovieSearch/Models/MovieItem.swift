//
//  MovieItem.swift
//  MovieSearch
//
//  Created by Shih-Han Hsu on 18/2/2024.
//

import Foundation

enum MoviewSection {
    case main
}

struct MovieItem: Hashable {
    let id: String
    let imageURL: String
    let title: String
    let releaseYear: String
    let userScore: String
    let genreList: [String]
    let overview: String
}
