//
//  GenresListResponse.swift
//  MovieSearch
//
//  Created by Shih-Han Hsu on 20/2/2024.
//

import Foundation

struct GenresResponse: Codable {
    let genres: [Genre]
}

struct Genre: Codable {
    let id: Int
    let name: String
}
