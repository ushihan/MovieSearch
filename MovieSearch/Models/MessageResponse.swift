//
//  MessageResponse.swift
//  MovieSearch
//
//  Created by Shih-Han Hsu on 21/2/2024.
//

import Foundation

struct MessageResponse: Codable {
    let code: Int
    let message: String

    enum CodingKeys: String, CodingKey {
        case code = "status_code"
        case message = "status_message"
    }
}


enum MessageCode: Int {
    case add = 1
    case updated = 12
    case remove = 13
}
