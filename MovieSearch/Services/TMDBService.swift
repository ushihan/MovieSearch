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

    private func getURLRequest(url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer " + TMDBService.apiKey, forHTTPHeaderField: "Authorization")
        return request
    }

    func fetchPopularMovies(page: Int = 1, completion: @escaping (Result<PopularMoviesResponse, Error>) -> Void) {
        let url = getURL(path: "/3/movie/popular", queryParameters: ["page": String(page)])
        let request = getURLRequest(url: url)

        session.dataTask(with: request) { data, _, error in
            guard let data = data, error == nil else {
                completion(.failure(error!))
                return
            }

            do {
                let moviesResponse = try JSONDecoder().decode(PopularMoviesResponse.self, from: data)
                completion(.success(moviesResponse))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }

    func fetchImageFullUrl(path: String) -> String {
        return getURL(path: "/t/p/original/" + path, isImage: true).absoluteString
    }
}
