//
//  MoviesManager.swift
//  I Knew It!
//
//  Created by Тимур Таймасов on 10.06.2021.
//

import Foundation
import Alamofire
import SwiftyJSON
import RealmSwift

/// Movies Manager Delegate Protocol
protocol MoviesManagerDelegate {
    func didUpdateMoviesList(_ moviesManager: MoviesManager, with moviesList: [MovieModel])
    func didFailWithError(error: Error)
}

/// All API networking stuff
struct MoviesManager {
    
    var delegate: MoviesManagerDelegate?
    
    /// Fuction that sends HTTP request on searching popular movies
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
        
        getPopularMovies(with: urlComponents) { movies in
            // Sends 10 of popular movies to findsimilar, so each film have 3 similar movies in model
            addsimilarMovies(to: Array(movies.shuffled().prefix(10)))
        }
    }
    
    /// Fuction that sends HTTP request on searching similar movies
    /// - Parameter id: ID of the movie  you want to find similar movies for
    func fetchsimilarMovies(by id: String,
                             completion: @escaping (_ similarMovies: [String]) -> Void) {
        
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.themoviedb.org"
        urlComponents.path = "/3/movie/\(id)/similar"
        urlComponents.queryItems = [
            URLQueryItem(name: "api_key", value: API.key),
            URLQueryItem(name: "language", value: API.language),
            URLQueryItem(name: "page", value: "1")
        ]
        
        getsimilarMovies(with: urlComponents) { similarMovies in
            completion(similarMovies)
        }
    }
    
    /// GET request fuction that recieves JSON data, then formatted to MovieModel array containing popular movies.
    /// - Parameter urlComponents: URLComponents containing:
    ///     - API path
    ///     - API Key
    ///     - Language code
    ///     - Page
    func getPopularMovies(with urlComponents: URLComponents,
                          completion: @escaping (_ movies: [MovieModel]) -> Void) {
        
        AF.request(urlComponents.url!, method: .get)
            .validate()
            .responseJSON(queue: DispatchQueue.global()) { response in
            
            switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    let movies = json["results"].compactMap { MovieModel(json: $0.1) }
                    
                    print("Movies data was loaded from the internet")
                    
                    completion(movies)
                    
                case .failure(let error):
                    delegate?.didFailWithError(error: error)
                    print(error, "\nCan't get movies data")
            }
        }
    }
    
    /// Finds 3 similar movies for each MovieModel in MovieModel array and writes it into similar property
    /// - Parameter movies: MovieModel array
    func addsimilarMovies(to movies: [MovieModel]) {
        
        for movie in movies {
            fetchsimilarMovies(by: movie.id) { similarMovies in
                // We only need 3 similar movies
                Array(similarMovies.shuffled().prefix(3)).forEach {
                    movie.similar.append($0)
                }
                //movie.similar = Array(similarMovies.shuffled().prefix(3))
            }
            delegate?.didUpdateMoviesList(self, with: movies)
        }
    }
    
    /// GET request function that recieves JSON data, containing array of similar movies
    /// - Parameter urlComponents: URLComponents containing:
    ///     - API path
    ///     - API Key
    ///     - Language code
    ///     - Page
    func getsimilarMovies(with urlComponents: URLComponents,
                           completion: @escaping (_ similarMovies: [String]) -> Void) {
        
        AF.request(urlComponents.url!, method: .get)
            .validate()
            .responseJSON(queue: DispatchQueue.global()) { response in
            
            switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    let similarMovies = json["results"]
                        .compactMap { $0.1["title"].stringValue }
                    
                    print("similar movies data was loaded from the internet")
                    
                    completion(similarMovies)
                    
                case .failure(let error):
                    delegate?.didFailWithError(error: error)
                    print(error, "\nCan't get similar movies data")
            }
        }
    }
}
