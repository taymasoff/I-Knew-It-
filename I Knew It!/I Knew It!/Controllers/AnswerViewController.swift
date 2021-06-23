//
//  AnswerViewController.swift
//  I Knew It!
//
//  Created by Тимур Таймасов on 18.06.2021.
//

import UIKit

class AnswerViewController: UIViewController {
    
    @IBOutlet weak var answerLabel: UILabel!
    @IBOutlet weak var moviePoster: UIImageView!
    
    var movie = MovieModel()
    
    override func viewDidLoad() {
        answerLabel.text = movie.title
        let link = "https://image.tmdb.org/t/p/original\(movie.posterPath)"
        moviePoster.downloaded(from: link, contentMode: .scaleAspectFit)
    }
    
    @IBAction func IKnewItPressed(_ sender: Any) {
        performSegue(withIdentifier: Segues.unwindToQuiz, sender: self)
    }
}
