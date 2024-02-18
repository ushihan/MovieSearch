//
//  TMDBServiceTests.swift
//  MovieSearchTests
//
//  Created by Shih-Han Hsu on 18/2/2024.
//

import XCTest
@testable import MovieSearch

final class TMDBServiceTests: XCTestCase {
    var service: TMDBService!

    override func setUpWithError() throws {
        super.setUp()
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        let session = URLSession(configuration: configuration)
        service = TMDBService(session: session)
    }

    override func tearDownWithError() throws {
        service = nil
        MockURLProtocol.mockResponseData = nil
        MockURLProtocol.response = nil
        MockURLProtocol.error = nil
        super.tearDown()
    }

    func testFetchPopularMoviesSuccess() {
        let expectation = self.expectation(description: "Fetch popular movies")

        let jsonData = """
        {
            "page": 1,
            "total_pages": 1,
            "total_results": 1,
            "results": [
                {
                    "adult": false,
                    "backdrop_path": "/testBackdropPath.jpg",
                    "genre_ids": [28, 12, 16],
                    "id": 100,
                    "original_language": "en",
                    "original_title": "Test Movie",
                    "overview": "Test Overview",
                    "popularity": 10.1,
                    "poster_path": "/testPosterPath.jpg",
                    "release_date": "2024-01-01",
                    "title": "Test Movie Title",
                    "video": false,
                    "vote_average": 8.5,
                    "vote_count": 100
                }
            ]
        }
        """.data(using: .utf8)!
        MockURLProtocol.mockResponseData = jsonData

        let url = URL(string: "https://api.themoviedb.org/3/movie/popular")!
        MockURLProtocol.response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)

        service.fetchPopularMovies(page: 1) { result in
            switch result {
            case .success(let response):
                XCTAssertEqual(response.page, 1)
                XCTAssertEqual(response.results.first?.id, 100)
                XCTAssertEqual(response.results.first?.title, "Test Movie Title")
                expectation.fulfill()
            case .failure(let error):
                XCTFail("Fetch popular movies failed: \(error)")
            }
        }

        waitForExpectations(timeout: 1, handler: nil)
    }
}
