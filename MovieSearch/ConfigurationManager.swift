//
//  ConfigurationManager.swift
//  MovieSearch
//
//  Created by Shih-Han Hsu on 18/2/2024.
//

import Foundation

class ConfigurationManager {

    static let shared = ConfigurationManager()

    private var configurations: NSDictionary?

    private init() {
        if let path = Bundle.main.path(forResource: "Config", ofType: "plist"),
           let dict = NSDictionary(contentsOfFile: path) {
            configurations = dict
        }
    }

    func getAPIKey() -> String {
        guard let apiKey = configurations?.object(forKey: "TMDBAPIKey") as? String, !apiKey.isEmpty else {
            fatalError("TMDBAPIKey is missing in Config.plist. Please ensure it's present and valid.")
        }
        return apiKey
    }
}
