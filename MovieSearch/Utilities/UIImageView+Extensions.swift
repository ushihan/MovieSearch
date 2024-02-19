//
//  UIImageView+Extensions.swift
//  MovieSearch
//
//  Created by Shih-Han Hsu on 19/2/2024.
//

import Foundation
import UIKit

extension UIImageView {

    func loadImage(from urlString: String) {
        let cacheKey = NSString(string: urlString)

        if let cachedImage = ImageCacheManager.shared.cache.object(forKey: cacheKey) {
            self.image = cachedImage
            return
        }

        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error downloading the image: \(error.localizedDescription)")
                return
            }

            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                print("Error: Invalid response or status code not 200")
                return
            }

            guard let data = data, let image = UIImage(data: data) else {
                print("Error: Image data could not be decoded")
                return
            }

            ImageCacheManager.shared.cache.setObject(image, forKey: cacheKey)

            DispatchQueue.main.async {
                self.image = image
            }
        }.resume()
    }
}
