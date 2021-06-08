//
//  QuizViewController.swift
//  I Knew It!
//
//  Created by Тимур Таймасов on 08.06.2021.
//

import UIKit

class QuizViewController: UIViewController {

    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var movieDescriptionLabel: UILabel!
    @IBOutlet weak var answerButton1: WhiteButton!
    @IBOutlet weak var answerButton2: WhiteButton!
    @IBOutlet weak var answerButton3: WhiteButton!
    @IBOutlet weak var answerButton4: WhiteButton!
    
    var seguedFromStartingVC = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TODO: Load and safe progress in userdefaults
        progressBar.progress = 0.1
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(seguedFromStartingVC ? false : true)
        
        if seguedFromStartingVC {
            hideUIElements()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        animateStuff()
    }
    
    func hideUIElements() {
        progressBar.alpha = 0.0
        questionLabel.alpha = 0.0
        movieDescriptionLabel.alpha = 0.0
        answerButton1.alpha = 0.0
        answerButton2.alpha = 0.0
        answerButton3.alpha = 0.0
        answerButton4.alpha = 0.0
    }
    
    func animateStuff() {
        if seguedFromStartingVC {
            animateBGColor()
            animateInterfaceReveal()
        }
    }
    
    func animateBGColor() {
        UIView.animate(withDuration: 1.0, delay: 0.0, options: .curveEaseOut, animations: {
                self.view.backgroundColor = Colors.mainBackground
            }, completion: nil)
    }
    
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
    
    @IBAction func answerButtonPressed(_ sender: UIButton) {
        
    }
    
}
