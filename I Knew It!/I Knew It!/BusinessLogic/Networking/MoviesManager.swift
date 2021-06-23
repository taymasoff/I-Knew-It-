//
//  MoviesManager.swift
//  I Knew It!
//
//  Created by Тимур Таймасов on 10.06.2021.
//

import Foundation
import Alamofire
import SwiftyJSON

protocol MoviesManagerDelegate {
    func didUpdateMoviesList(_ moviesManager: MoviesManager, with moviesList: [MovieModel])
    func didFailWithError(error: Error)
}

struct MoviesManager {
    
    var delegate: MoviesManagerDelegate?
    
    let requestAssembler = RequestAssembler()
    
    /*
     The idia was to find 10 random popular-ish movies then add 3 similar to them.
     Simple, right? Turns out, not every movie have similar movies.
     The, other way is to find 'recommended' movies. Well... Not every movie have
         recommended too.
     I will try both of these, if failed, I will fill up empty spots with just random
         movies.
     */
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
                
                /* There might be less than 3 similar movies in array,
                so we have to fill them with recommended or random movies.
                This function makes sure of it.
                */
                addMissingSimilarMovies(movieID: movie.id,
                                        movies: similarMovies) { similarMovies in
                    
                    similarMovies.forEach {
                        movie.similar.append($0)
                    }
                    
                    group.leave()
                }
                
            }
        }
        group.wait()
        callback(movies)
    }
    
    /// Fills missing movies in similarMovies array if there are any
    /// - Parameters:
    ///   - movieID: movie id
    ///   - movies: similar movies array
    func addMissingSimilarMovies(movieID: String, movies: [String],
                                 callback: @escaping (_ movies: [String]) -> Void) {
        
        // This might be the dumbest realization 🤦🤦🤦
        
        var similarMovies = movies
        var missingMovies = 3 - similarMovies.count
        
        if missingMovies > 0 {
            let recommendedRequest = requestAssembler.assembleRecommendedMoviesRequest(id: movieID)
            
            getRecommendedMovies(with: recommendedRequest) { recommendedMovies in
                similarMovies.append(contentsOf: recommendedMovies.shuffled().prefix(missingMovies))
                
                missingMovies = 3 - similarMovies.count
                
                if missingMovies > 0 {
                    let randomMoviesRequest = requestAssembler.assembleRandomMoviesRequest()
                    getRandomMovies(with: randomMoviesRequest) { randomMovies in
                        similarMovies.append(contentsOf: randomMovies.shuffled().prefix(missingMovies))
                        
                        callback(similarMovies)
                    }
                } else {
                    callback(similarMovies)
                }
            }
        } else {
            callback(similarMovies)
        }
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
                    let movies = json["results"]
                        .compactMap { MovieModel(json: $0.1) }
                    
                    print("Popular movies was loaded from the internet")
                    
                    callback(movies)
                    
                case .failure(let error):
                    print(error, "\nError in getPopularMovies")
                    delegate?.didFailWithError(error: error)
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
                    
                    print("Similar movies data was loaded from the internet")
                    
                    callback(similarMovies)
                    
                case .failure(let error):
                    print(error, "\nError in getSimilarMovies")
                    delegate?.didFailWithError(error: error)
            }
        }
    }
    
    /// GET request function that recieves JSON data, containing array of recommended movies
    /// - Parameter urlComponents: URLComponents containing:
    ///     - API path
    ///     - API Key
    ///     - Language code
    ///     - Page
    func getRecommendedMovies(with request: URLRequest,
                           callback: @escaping (_ recommendedMovies: [String]) -> Void) {
        
        AF.request(request)
            .validate()
            .responseJSON(queue: DispatchQueue.global()) { response in
            
            switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    let recommendedMovies = json["results"]
                        .compactMap { $0.1["title"].stringValue }
                    
                    print("Recommended movies data was loaded from the internet")
                    
                    callback(recommendedMovies)
                    
                case .failure(let error):
                    print(error, "\nError in getRecommendedMovies")
                    delegate?.didFailWithError(error: error)
            }
        }
    }
    
    /// GET request function that recieves JSON data, containing array of random movies
    /// - Parameter urlComponents: URLComponents containing:
    ///     - API path
    ///     - API Key
    ///     - Language code
    ///     - Page
    func getRandomMovies(with request: URLRequest,
                           callback: @escaping (_ randomMovies: [String]) -> Void) {
        
        AF.request(request)
            .validate()
            .responseJSON(queue: DispatchQueue.global()) { response in
            
            switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    let randomMovies = json["results"]
                        .compactMap { $0.1["title"].stringValue }
                    
                    print("Random movies data was loaded from the internet")
                    
                    callback(randomMovies)
                    
                case .failure(let error):
                    print(error, "\nError in getRandomMovies")
                    delegate?.didFailWithError(error: error)
            }
        }
    }
    
    
}
