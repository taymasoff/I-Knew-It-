//
//  MoviesManager.swift
//  I Knew It!
//
//  Created by Тимур Таймасов on 10.06.2021.
//

import Foundation
import Alamofire
import SwiftyJSON

/// Movies Manager Delegate Protocol
protocol MoviesManagerDelegate {
    func didUpdateMoviesList(_ moviesManager: MoviesManager)
    func didFailWithError(error: Error)
}

/// All API networking stuff
struct MoviesManager {
    
    var delegate: MoviesManagerDelegate?
    
    /// Fuction that sends parameters to HTTP request
    func fetchMovies() {
    
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.themoviedb.org"
        urlComponents.path = "/3/movie/popular"
        urlComponents.queryItems = [
            URLQueryItem(name: "api_key", value: API.key),
            URLQueryItem(name: "language", value: API.language),
            URLQueryItem(name: "page", value: "\(Int.random(in: 1...50))")
        ]
        print(urlComponents)
        performRequest(with: urlComponents)
    }
    
    /// Alamofire GET request fuction that recieves JSON data, converted to MovieModel array and sent to Realm DB
    /// - Parameter urlComponents: URLComponents, containing:
    ///     - API path
    ///     - API Key
    ///     - Language code
    ///     - Page
    func performRequest(with urlComponents: URLComponents) {
        
        AF.request(urlComponents.url!, method: .get)
            .validate()
            .responseJSON(queue: DispatchQueue.global()) { response in
            
            switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    let movies = json["results"].compactMap { MovieModel(json: $0.1) }
                    RealmRecords.saveMoviesData(movies: movies)
                    delegate?.didUpdateMoviesList(self)
                    print("Movies data was loaded from the internet")
                case .failure(let error):
                    delegate?.didFailWithError(error: error)
                    print(error, "\nCan't get movies data")
            }
        }
    }
}
