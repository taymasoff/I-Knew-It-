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

protocol MoviesManagerDelegate {
    func didUpdateMoviesList(_ moviesManager: MoviesManager, with moviesList: [MovieModel])
    func didFailWithError(error: Error)
}

struct MoviesManager {
    
    var delegate: MoviesManagerDelegate?
    
    let requestAssembler = RequestAssembler()
    
    /// Gets 10 movies with 3 similar movies in it
    func getMovies() {
        let movieRequest = requestAssembler.assemblePopularMoviesRequest()
        
        getPopularMovies(with: movieRequest) { movies in
            // Sends 10 of popular movies to findsimilar, so each film have 3 similar movies in model
            addSimilarMovies(to: Array(movies.prefix(10))) { movies in
                delegate?.didUpdateMoviesList(self, with: movies)
            }
        }
        
    }
    
    /// Finds 3 similar movies for each movie in array and writes it into similar property
    /// - Parameter movies: Array of MovieModel objects
    func addSimilarMovies(to movies: [MovieModel],
                          callback: (_ movies: [MovieModel]) -> Void) {
        // We need to finish all tasks before executing callback
        let group = DispatchGroup()
        for movie in movies {
            group.enter()
            let request = requestAssembler.assembleSimilarMoviesRequest(id: movie.id)
            getSimilarMovies(with: request) { similarMovies in
                // We only need 3 similar movies
                Array(similarMovies.shuffled().prefix(3)).forEach {
                    movie.similar.append($0)
                }
                group.leave()
            }
        }
        group.wait()
        callback(movies)
    }
    
    /// GET request fuction that recieves JSON data, then formatted to MovieModel array containing popular movies.
    /// - Parameter urlComponents: URLComponents containing:
    ///     - API path
    ///     - API Key
    ///     - Language code
    ///     - Page
    func getPopularMovies(with request: URLRequest,
                          callback: @escaping (_ movies: [MovieModel]) -> Void) {
        
        AF.request(request)
            .validate()
            .responseJSON(queue: DispatchQueue.global()) { response in
            
            switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    let movies = json["results"].compactMap { MovieModel(json: $0.1) }
                    
                    print("Movies data was loaded from the internet")
                    
                    callback(movies)
                    
                case .failure(let error):
                    delegate?.didFailWithError(error: error)
                    print(error, "\nCan't get movies data")
            }
        }
    }
    
    /// GET request function that recieves JSON data, containing array of similar movies
    /// - Parameter urlComponents: URLComponents containing:
    ///     - API path
    ///     - API Key
    ///     - Language code
    ///     - Page
    func getSimilarMovies(with request: URLRequest,
                           callback: @escaping (_ similarMovies: [String]) -> Void) {
        
        AF.request(request)
            .validate()
            .responseJSON(queue: DispatchQueue.global()) { response in
            
            switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    let similarMovies = json["results"]
                        .compactMap { $0.1["title"].stringValue }
                    
                    print("similar movies data was loaded from the internet")
                    
                    callback(similarMovies)
                    
                case .failure(let error):
                    delegate?.didFailWithError(error: error)
                    print(error, "\nCan't get similar movies data")
            }
        }
    }
}
