//
//  TMDBService.swift
//  MovieSearch
//
//  Created by Shih-Han Hsu on 18/2/2024.
//

import Foundation

class TMDBService {
    
    static let shared = TMDBService()
    private static let apiHost = "api.themoviedb.org"
    private static let imageHost = "image.tmdb.org"
    private static let apiKey = ConfigurationManager.shared.getAPIKey()
    private static let accountId = ConfigurationManager.shared.getAccountId()

    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    private func getURL(path: String, queryParameters: [String: String] = [:], isImage: Bool = false) -> URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = isImage == true ? TMDBService.imageHost : TMDBService.apiHost
        components.path = path

        components.queryItems = queryParameters.map { URLQueryItem(name: $0.key, value: $0.value) }

        guard let url = components.url else {
            fatalError("Failed to construct URL. Check scheme, host, and path.")
        }
        return url
    }

    private func getURLRequest(url: URL, method: String = "GET", postData: [String : Any]? = nil) -> URLRequest {
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer " + TMDBService.apiKey, forHTTPHeaderField: "Authorization")
        request.httpMethod = method
        if let postData = postData {
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: postData, options: [])
            } catch let error {
                print("Error serializing postData to JSON: \(error)")
            }
        }
        return request
    }

    func fetchMovieGenre() async throws -> GenresResponse {
        let url = getURL(path: "/3/genre/movie/list")
        let request = getURLRequest(url: url)

        let (data, _) = try await session.data(for: request)
        let genreResponse = try JSONDecoder().decode(GenresResponse.self, from: data)
        return genreResponse
    }

    func fetchPopularMovies(page: Int = 1) async throws -> MoviesResponse {
        let url = getURL(path: "/3/movie/popular", queryParameters: ["page": String(page)])
        let request = getURLRequest(url: url)

        let (data, _) = try await session.data(for: request)
        let movieResponse = try JSONDecoder().decode(MoviesResponse.self, from: data)
        return movieResponse
    }

    func searchMovies(keyword: String) async throws -> MoviesResponse {
        let url = getURL(path: "/3/search/movie", queryParameters: ["query": keyword])
        let request = getURLRequest(url: url)

        let (data, _) = try await session.data(for: request)
        let movieResponse = try JSONDecoder().decode(MoviesResponse.self, from: data)
        return movieResponse
    }

    func fetchMyFavorite(page: Int = 1) async throws -> MoviesResponse {
        let url = getURL(path: "/3/account/" + TMDBService.accountId  + "/favorite/movies", queryParameters: ["page": String(page)])
        let request = getURLRequest(url: url)

        let (data, _) = try await session.data(for: request)
        let response = try JSONDecoder().decode(MoviesResponse.self, from: data)
        return response
    }

    func setFavorite(movieId: String, favorite: Bool) async throws -> MessageResponse {
        let url = getURL(path: "/3/account/" + TMDBService.accountId  + "/favorite")
        let parameters = ["media_type": "movie", "media_id": movieId, "favorite": favorite] as [String : Any]
        let request = getURLRequest(url: url, method: "POST", postData: parameters)

        let (data, _) = try await session.data(for: request)
        let response = try JSONDecoder().decode(MessageResponse.self, from: data)
        return response
    }

    func fetchRatedMovies(page: Int = 1) async throws -> MoviesResponse {
        let url = getURL(path: "/3/account/" + TMDBService.accountId  + "/rated/movies", queryParameters: ["page": String(page)])
        let request = getURLRequest(url: url)

        let (data, _) = try await session.data(for: request)
        let response = try JSONDecoder().decode(MoviesResponse.self, from: data)
        return response
    }

    func addRating(movieId: String, score: Float) async throws -> MessageResponse {
        let url = getURL(path: "/3/movie/" + movieId  + "/rating")
        let parameters = ["value": score] as [String : Any]
        let request = getURLRequest(url: url, method: "POST", postData: parameters)

        let (data, _) = try await session.data(for: request)
        let response = try JSONDecoder().decode(MessageResponse.self, from: data)
        return response
    }

    func resetRating(movieId: String) async throws -> MessageResponse {
        let url = getURL(path: "/3/movie/" + movieId  + "/rating")
        let request = getURLRequest(url: url, method: "DELETE")

        let (data, _) = try await session.data(for: request)
        let response = try JSONDecoder().decode(MessageResponse.self, from: data)
        return response
    }

    func fetchImage(path: String) async throws -> Data {
        let url = getURL(path: "/t/p/original/" + path, isImage: true)
        let request = getURLRequest(url: url)
        let (data, response) = try await session.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        return data
    }
}
