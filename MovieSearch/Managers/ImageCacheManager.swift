//
//  ImageCacheManager.swift
//  MovieSearch
//
//  Created by Shih-Han Hsu on 19/2/2024.
//

import Foundation
import UIKit
import Combine

enum ImageError: Error {
    case dataDecodingFailed
}

enum MovieImageType: String {
    case poster = "poster"
    case backdrop = "backdrop"

    static func from(id: String) -> MovieImageType? {
        for type in [MovieImageType.poster, MovieImageType.backdrop] {
            if id.hasPrefix(type.rawValue) {
                return type
            }
        }
        return nil
    }

    static func getOriginalId(id: String) -> String? {
        for type in [MovieImageType.poster, MovieImageType.backdrop] {
            if id.hasPrefix(type.rawValue) {
                return id.replacingOccurrences(of: type.rawValue, with: "")
            }
        }
        return nil
    }
}

class ImageCacheManager {

    static let shared = ImageCacheManager()
    private let cache = NSCache<NSString, UIImage>()
    var cacheUpdatePublisher = PassthroughSubject<(id: String, image: UIImage), Never>()

    private init() {
        cache.totalCostLimit = 1024 * 1024 * 200 // 200MB
    }

    func loadImage(id: String, from urlString: String) -> UIImage? {
        let cacheKey = NSString(string: urlString)

        if let cachedImage = ImageCacheManager.shared.cache.object(forKey: cacheKey) {
            return cachedImage
        }

        Task {
            do {
                let data = try await TMDBService.shared.fetchImage(path: urlString)
                guard let image = UIImage(data: data) else {
                    throw ImageError.dataDecodingFailed
                }

                self.cache.setObject(image, forKey: NSString(string: urlString))
                self.cacheUpdatePublisher.send((id: id, image: image))
            } catch {
                // Error handling
                print(error)
            }
        }
        return nil
    }
}
