//
//  QuizViewController.swift
//  I Knew It!
//
//  Created by Тимур Таймасов on 08.06.2021.
//

import UIKit
import RealmSwift

class QuizViewController: UIViewController {

    // MARK: - Private Properties
    
    @IBOutlet fileprivate weak var progressBar: UIProgressView!
    @IBOutlet fileprivate weak var questionLabel: UILabel!
    @IBOutlet fileprivate weak var movieDescriptionLabel: UILabel!
    @IBOutlet fileprivate weak var answerButton1: WhiteButton!
    @IBOutlet fileprivate weak var answerButton2: WhiteButton!
    @IBOutlet fileprivate weak var answerButton3: WhiteButton!
    @IBOutlet fileprivate weak var answerButton4: WhiteButton!
    
    private var moviesManager = MoviesManager()
    
    private var movies: Results<MovieModel> = {
        let realm = try! Realm()
        return realm.objects(MovieModel.self)
    }()
    
    // MARK: - Internal Properties
    
    var seguedFromStartingVC = false
    
    // MARK: - ViewController Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        if movies.isEmpty {
//            getNewMovies()
//        }
        
        getNewMovies()
        
        moviesManager.delegate = self
        
        // TODO: Load and safe progress in userdefaults later
        progressBar.progress = 0.1
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(seguedFromStartingVC ? false : true)
        
        // Hide elements in order to see animation
        hideUIElements()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        // Loading Spinner
        DispatchQueue.main.async {
            self.showSpinner(on: self.view)
        }
    }
    
}

// MARK: - Private Extension - Private Methods
private extension QuizViewController {
    
    // MARK: - UI and Animations
    
    /// Hides all UI Elements
    func hideUIElements() {
        if seguedFromStartingVC {
            progressBar.alpha = 0.0
            questionLabel.alpha = 0.0
            movieDescriptionLabel.alpha = 0.0
            answerButton1.alpha = 0.0
            answerButton2.alpha = 0.0
            answerButton3.alpha = 0.0
            answerButton4.alpha = 0.0
        }
    }
    
    // TODO: ----
    func showUI() {
        
        // TODO: Add functionality, so user gets a new films every time he runs out of them
        let currentProgress = 0
        //
        
        movieDescriptionLabel.text = movies[currentProgress].overview
        answerButton1.setTitle(movies[currentProgress].title, for: .normal)
        answerButton2.setTitle(movies[currentProgress].similar[0], for: .normal)
        answerButton3.setTitle(movies[currentProgress].similar[1], for: .normal)
        answerButton4.setTitle(movies[currentProgress].similar[2], for: .normal)
        
        animateStuff()
    }
    
    /// Perform animations
    func animateStuff() {
        if seguedFromStartingVC {
            animateBGColor()
            animateInterfaceReveal()
        }
    }
    
    /// Animate BGColor change
    func animateBGColor() {
        UIView.animate(withDuration: 1.0, delay: 0.0, options: .curveEaseOut, animations: {
                self.view.backgroundColor = Colors.mainBackground
            }, completion: nil)
    }
    
    /// Animate UI Elements to FadeIn
    func animateInterfaceReveal() {
        UIView.animate(
            withDuration: 1.5,
            delay: 0.6,
            options: .curveEaseIn,
            animations: {
                self.progressBar.alpha = 1.0
                self.questionLabel.alpha = 1.0
                self.movieDescriptionLabel.alpha = 1.0
                self.answerButton1.alpha = 1.0
                self.answerButton2.alpha = 1.0
                self.answerButton3.alpha = 1.0
                self.answerButton4.alpha = 1.0
            }, completion: nil)
    }
    
    // MARK: - Data managing
    
    /// Loads movies data from the internet with loading spinner on screen while loading
    func getNewMovies() {
        
        // Loading Spinner
        DispatchQueue.main.async {
            self.showSpinner(on: self.view)
        }
        
        moviesManager.fetchMovies()
    }
    
    // MARK: - Actions
    @IBAction func answerButtonPressed(_ sender: UIButton) {
        
    }
}

// MARK: - Movies Manager Delegate
extension QuizViewController: MoviesManagerDelegate {
   
    /// Function that tracks when the request is complete and response is recieved
    /// - Parameter moviesManager: Network service
    /// - Parameter moviesList: Movies list loaded from internet
    func didUpdateMoviesList(_ moviesManager: MoviesManager,
                             with moviesList: [MovieModel]) {
        
        DispatchQueue.main.async {
            self.removeSpinner()
        }
        
        // Saving movies array into Realm
        RealmRecords.saveMoviesData(movies: moviesList)
    }
    
    /// Function that informs if some error occured during the network request
    /// - Parameter error: Error description
    func didFailWithError(error: Error) {
        fatalError("\(error)")
    }
    
}
