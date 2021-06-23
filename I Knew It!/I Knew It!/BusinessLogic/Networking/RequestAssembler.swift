//
//  RequestAssembler.swift
//  I Knew It!
//
//  Created by Тимур Таймасов on 16.06.2021.
//

import Foundation

struct RequestAssembler {
    
    /// Assembles url components to popular movies request
    /// - Parameter difficulty: how hard questions should be:
    ///     - .easy
    ///     - .medium
    ///     - .hard
    /// - Returns: URL request
    func assemblePopularMoviesRequest(difficulty: Difficulty = .easy) -> URLRequest {
        
        // First pages are more popular, i.e. easier to guess
        var page: String {
            switch difficulty {
            case .easy:
                return String(Int.random(in: 1...20))
            case .medium:
                return String(Int.random(in: 21...40))
            case .hard:
                return String(Int.random(in: 41...60))
            }
        }
        
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.themoviedb.org"
        urlComponents.path = "/3/movie/popular"
        urlComponents.queryItems = [
            URLQueryItem(name: "api_key", value: API.key),
            URLQueryItem(name: "language", value: API.language),
            URLQueryItem(name: "page", value: page)
        ]
        
        var request = URLRequest(url: urlComponents.url!)
        request.httpMethod = "GET"
        
        return request
    }
    
    /// Assembles url components to similar movies request
    /// - Parameter id: movie id
    /// - Returns: url request
    func assembleSimilarMoviesRequest(id: String) -> URLRequest {
        
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.themoviedb.org"
        // Not every movie have similar movies, so I changed it to recommended movies
        urlComponents.path = "/3/movie/\(id)/similar"
        urlComponents.queryItems = [
            URLQueryItem(name: "api_key", value: API.key),
            URLQueryItem(name: "language", value: API.language),
            URLQueryItem(name: "page", value: "1")
        ]
        
        var request = URLRequest(url: urlComponents.url!)
        request.httpMethod = "GET"
        
        return request
    }
    
    /// Assembles url components to recommended movies request
    /// - Parameter id: movie id
    /// - Returns: url request
    func assembleRecommendedMoviesRequest(id: String) -> URLRequest {
        
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.themoviedb.org"
        // Not every movie have similar movies, so I changed it to recommended movies
        urlComponents.path = "/3/movie/\(id)/recommendations"
        urlComponents.queryItems = [
            URLQueryItem(name: "api_key", value: API.key),
            URLQueryItem(name: "language", value: API.language),
            URLQueryItem(name: "page", value: "1")
        ]
        
        var request = URLRequest(url: urlComponents.url!)
        request.httpMethod = "GET"
        
        return request
    }
    
    /// Assembles url components to random movies request
    /// - Parameter id: movie id
    /// - Returns: url request
    func assembleRandomMoviesRequest() -> URLRequest {
        
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.themoviedb.org"
        // Not every movie have similar movies, so I changed it to recommended movies
        urlComponents.path = "/3/discover/movie"
        urlComponents.queryItems = [
            URLQueryItem(name: "api_key", value: API.key),
            URLQueryItem(name: "sort_by", value: "popularity.desc"),
            URLQueryItem(name: "language", value: API.language),
            URLQueryItem(name: "page", value: String(Int.random(in: 1...50)))
        ]
        
        var request = URLRequest(url: urlComponents.url!)
        request.httpMethod = "GET"
        
        return request
    }
}
