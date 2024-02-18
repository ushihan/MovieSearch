//
//  PopularMoviesTests.swift
//  MovieSearchTests
//
//  Created by Shih-Han Hsu on 18/2/2024.
//

import XCTest
@testable import MovieSearch

final class PopularMovieTests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testPopularMovieResponseDecoding() throws {
        let json = """
               {
                   "page": 1,
                   "total_pages": 10,
                   "total_results": 100,
                   "results": [
                       {
                           "adult": false,
                           "backdrop_path": "/Backdrop.jpg",
                           "genre_ids": [1, 2, 3],
                           "id": 123,
                           "original_language": "en",
                           "original_title": "Original Title",
                           "overview": "An overview",
                           "popularity": 9.8,
                           "poster_path": "/pathToPoster.jpg",
                           "release_date": "2020-01-01",
                           "title": "Test Movie",
                           "video": false,
                           "vote_average": 8.5,
                           "vote_count": 100
                       }
                   ]
               }
               """.data(using: .utf8)!
        do {
            let decodedResponse = try JSONDecoder().decode(PopularMoviesResponse.self, from: json)
            XCTAssertEqual(decodedResponse.page, 1)
            XCTAssertEqual(decodedResponse.totalPages, 10)
            XCTAssertEqual(decodedResponse.totalResults, 100)
            XCTAssertEqual(decodedResponse.results.count, 1)

            let movie = decodedResponse.results.first!
            XCTAssertEqual(movie.id, 123)
            XCTAssertEqual(movie.originalTitle, "Original Title")
            XCTAssertEqual(movie.overview, "An overview")
            XCTAssertEqual(movie.popularity, 9.8)
            XCTAssertEqual(movie.voteAverage, 8.5)
            XCTAssertEqual(movie.voteCount, 100)
        } catch {
            XCTFail("Decoding failed with error: \(error)")
        }
    }
}
