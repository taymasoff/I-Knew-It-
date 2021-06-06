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
        // TODO: Save and import progress from userdefaults later
        let progress = 1
        if progress != 0 {
            descriptionLabel.text = "You current progress is ... ."
            acceptButton.setTitle("Continue", for: .normal)
        }
    }
}

// MARK: - Private Extension - private methods
private extension StartingViewController {
    
    // MARK: - Animations Management
    func animateStuff() {
        if !animationPerformedOnce {
            animateLogoStackView()
            fadeInDescriptionLabel()
            fadeInButton()
            
            animationPerformedOnce = true
        }
    }
    
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
    
    func fadeInDescriptionLabel() {
        descriptionLabel.alpha = 0.0
        UIView.animate(
            withDuration: 1.0,
            delay: 1.0,
            options: .curveEaseIn,
            animations: {
                self.descriptionLabel.alpha = 1.0
            }, completion: nil)
    }

    func fadeInButton() {
        acceptButton.alpha = 0.0
        UIView.animate(
            withDuration: 1.0,
            delay: 2.5,
            options: .curveEaseIn,
            animations: {
                self.acceptButton.alpha = 1.0
            }, completion: nil)
    }
    
    // MARK: - Actions
    
    @IBAction func acceptButtonPressed(_ sender: UIButton) {
        
    }
    
}
