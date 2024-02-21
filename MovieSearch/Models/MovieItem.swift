//
//  MovieItem.swift
//  MovieSearch
//
//  Created by Shih-Han Hsu on 18/2/2024.
//

import Foundation
import UIKit

enum MovieSection {
    case main
}

struct MovieItem: Hashable {
    let id: String
    var backdropImage: UIImage?
    var image: UIImage?
    let title: String
    let releaseYear: String
    let userScore: String
    let genreList: [String]
    let genreIds: [Int]
    let overview: String
    let myRating: String?
}
