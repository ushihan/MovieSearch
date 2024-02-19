//
//  ImageCacheManager.swift
//  MovieSearch
//
//  Created by Shih-Han Hsu on 19/2/2024.
//

import Foundation
import UIKit

class ImageCacheManager {

    static let shared = ImageCacheManager()
    let cache = NSCache<NSString, UIImage>()

    private init() {
        cache.countLimit = 100
    }
}
