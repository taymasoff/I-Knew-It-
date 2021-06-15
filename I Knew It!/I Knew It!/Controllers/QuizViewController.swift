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
    
    // TODO: Progress..
    private var currentProgress = 0
    
    private var movies: Results<MovieModel> = {
        let realm = try! Realm()
        return realm.objects(MovieModel.self)
    }()
    
    private var moviesNotificationToken: NotificationToken?
    deinit {
        moviesNotificationToken?.invalidate()
    }
    
    // MARK: - Internal Properties
    
    var seguedFromStartingVC = false
    
    // MARK: - ViewController Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        moviesManager.delegate = self
        
        // Hide elements in order to see animations
        hideUIElements()
        
        // Movies data observer. Controls UI reveal when data changes.
        trackMoviesChange()
        
        // TODO: Load and safe progress in userdefaults later
        progressBar.progress = 0.1
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        // Change BG color right away
        if self.seguedFromStartingVC {
            self.animateBGColor()
        }
    }
    
}

// MARK: - Private Extension - Private Methods
private extension QuizViewController {
    
    // MARK: - UI and Animations
    
    /// Hides all UI Elements
    func hideUIElements() {
        progressBar.alpha = 0.0
        questionLabel.alpha = 0.0
        movieDescriptionLabel.alpha = 0.0
        answerButton1.alpha = 0.0
        answerButton2.alpha = 0.0
        answerButton3.alpha = 0.0
        answerButton4.alpha = 0.0
    }
    
    // TODO: progress
    /// Puts data to UI and reveals it to the user
    func showUI() {
        
        movieDescriptionLabel.text = movies[currentProgress].overview
        answerButton1.setTitle(movies[currentProgress].title, for: .normal)
        answerButton2.setTitle(movies[currentProgress].similar[0], for: .normal)
        answerButton3.setTitle(movies[currentProgress].similar[1], for: .normal)
        answerButton4.setTitle(movies[currentProgress].similar[2], for: .normal)

        animateInterfaceReveal()
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
            delay: 0.5,
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
    
    /// Tracks any changes to realm movie object and updates UI accordingly
    private func trackMoviesChange() {
        moviesNotificationToken = movies.observe({ [unowned self] change in
            switch change {
            case .initial(_):
                self.hideUIElements()
                if self.movies.isEmpty {
                    self.moviesManager.fetchMovies()
                } else {
                    self.showUI()
                }
            case .update:
                self.hideUIElements()
                self.showUI()
            case .error(let error):
                print(error.localizedDescription)
            }
        })
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
        
        // Saving movies array into Realm
        RealmRecords.saveMoviesData(movies: moviesList)
    }
    
    /// Function that informs if some error occured during the network request
    /// - Parameter error: Error description
    func didFailWithError(error: Error) {
        fatalError("\(error)")
    }
    
}
