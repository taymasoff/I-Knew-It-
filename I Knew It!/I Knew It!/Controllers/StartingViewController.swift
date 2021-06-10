//
//  StartingViewController.swift
//  I Knew It!
//
//  Created by Тимур Таймасов on 27.05.2021.
//

import UIKit

class StartingViewController: UIViewController {
    
    // MARK: - Private Properties
    
    @IBOutlet fileprivate weak var logoStackView: UIStackView!
    @IBOutlet fileprivate weak var logoStackViewCenterYConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate weak var descriptionLabel: UILabel!
    @IBOutlet fileprivate weak var acceptButton: PurpleButton!
    
    // MARK: - Internal Properties
    
    var animationPerformedOnce = false
    
    // MARK: - ViewController Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if !animationPerformedOnce {
            hideUIElements()
        }
        
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        animateStuff()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated);
        super.viewWillDisappear(animated)
    }
    
    // MARK: - Segue Methods
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // TODO: Save and import progress from userdefaults
        let progress = 1
        if progress != 0 {
            descriptionLabel.text = "You current progress is ... ."
            acceptButton.setTitle("Continue", for: .normal)
        }
        
        // Make sure QuizVC have appropriate background color to match the button color
        if segue.identifier == Segues.toQuiz {
            if let destinationVC = segue.destination as? QuizViewController {
                destinationVC.view.backgroundColor = Colors.purple
                destinationVC.seguedFromStartingVC = true
            }
        }
    }
}

// MARK: - Private Extension - Private Methods
private extension StartingViewController {
    
    // MARK: - Animations Management
    
    /// Hides some elements for fadeIn animation
    func hideUIElements() {
        descriptionLabel.alpha = 0.0
        acceptButton.alpha = 0.0
    }
    
    /// Do all animations needed at view appearance
    func animateStuff() {
        if !animationPerformedOnce {
            animateLogoStackView()
            fadeInDescriptionLabel()
            fadeInButton()
            
            animationPerformedOnce = true
        }
    }
    
    /// Moves logo and appname label slightly up
    func animateLogoStackView() {
        UIView.animate(
            withDuration: 1.0,
            delay: 0.2,
            options: .curveEaseInOut,
            animations: {
                self.logoStackViewCenterYConstraint.constant -= self.view.bounds.height/6
                self.view.layoutIfNeeded()
            }, completion: nil)
    }
    
    /// Fade In label animation
    func fadeInDescriptionLabel() {
        UIView.animate(
            withDuration: 1.0,
            delay: 1.0,
            options: .curveEaseIn,
            animations: {
                self.descriptionLabel.alpha = 1.0
            }, completion: nil)
    }
    
    /// Fade In button animation
    func fadeInButton() {
        UIView.animate(
            withDuration: 1.0,
            delay: 1.5,
            options: .curveEaseIn,
            animations: {
                self.acceptButton.alpha = 1.0
            }, completion: nil)
    }
    
    /// Does a 'dive' effect transition by scaling up the button
    func animateButtonDive() {
        
        // Hides button's text first
        UIView.animate(
            withDuration: 0.2,
            delay: 0.0,
            options: .curveEaseOut,
            animations: {
                self.acceptButton.titleLabel?.alpha = 0.0
            }, completion: { _ in
                // Scales button to the size of the screen to make a nice transition into
                // the second view
                let acceptButtonLastPosition = self.acceptButton.center
                UIView.animate(
                    withDuration: 1.0,
                    delay: 0.0,
                    options: [.preferredFramesPerSecond60, .curveEaseIn],
                    animations: {
                        self.acceptButton.transform = CGAffineTransform(
                            scaleX: self.view.frame.width/self.acceptButton.frame.width,
                            y: self.view.frame.height/self.acceptButton.frame.height)
                        self.acceptButton.center = self.view.center
                        self.acceptButton.layer.cornerRadius = 0
                        
                    }, completion: { _ in
                        // Performs non-animated segue as soon as button fills the screen
                        self.performSegue(withIdentifier: Segues.toQuiz, sender: nil)
                        
                        // Brings it all back to original values
                        self.acceptButton.transform = CGAffineTransform.identity
                        self.acceptButton.titleLabel?.alpha = 1.0
                        self.acceptButton.layer.cornerRadius = 5
                        self.acceptButton.center = acceptButtonLastPosition
                    })
            })
    }
    
    // MARK: - Actions
    
    @IBAction func acceptButtonPressed(_ sender: UIButton) {
        animateButtonDive()
    }
    
}
