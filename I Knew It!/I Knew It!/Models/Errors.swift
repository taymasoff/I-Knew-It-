//
//  Errors.swift
//  I Knew It!
//
//  Created by Тимур Таймасов on 16.06.2021.
//

import Foundation

//enum GameError: Error {
//    case progressNotFound
//}
//
//extension GameError {
//    var description: String? {
//        switch self {
//        case .progressNotFound:
//            return "Could not find the game progress in UserDefaults"
//        }
//    }
//}

enum NetworkError: Error {
    case invalidURL
}

extension NetworkError {
    var description: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        }
    }
}
