//
//  QuizViewController.swift
//  I Knew It!
//
//  Created by Тимур Таймасов on 08.06.2021.
//

import UIKit

class QuizViewController: UIViewController {

    // MARK: - Private Properties
    
    @IBOutlet fileprivate weak var progressBar: UIProgressView!
    @IBOutlet fileprivate weak var questionLabel: UILabel!
    @IBOutlet fileprivate weak var movieDescriptionLabel: UILabel!
    @IBOutlet fileprivate weak var answerButton1: WhiteButton!
    @IBOutlet fileprivate weak var answerButton2: WhiteButton!
    @IBOutlet fileprivate weak var answerButton3: WhiteButton!
    @IBOutlet fileprivate weak var answerButton4: WhiteButton!
    
    // MARK: - Internal Properties
    
    var seguedFromStartingVC = false
    
    // MARK: - ViewController Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        animateStuff()
    }
    
}

// MARK: - Private Extension - Private Methods
private extension QuizViewController {
    
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
    
    // MARK: - Actions
    @IBAction func answerButtonPressed(_ sender: UIButton) {
        
    }
}
