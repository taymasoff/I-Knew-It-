//
//  ProgressManager.swift
//  I Knew It!
//
//  Created by Тимур Таймасов on 17.06.2021.
//

import Foundation

class ProgressManager {
    
    // MARK: - Singleton
    static let shared = ProgressManager()
    
    private let key = "progress"
    
    var currentProgress: Int = 0 {
        didSet {
            if oldValue >= 9 {
                currentProgress = 0
            }
        }
    }
    
    private init() {
        loadProgress()
    }
    
    func saveProgress() {
        UserDefaults.standard.setValue(currentProgress, forKey: key)
        print("Progress save method called with value of \(currentProgress)")
    }
    
    func loadProgress() {
        guard let progress = UserDefaults.standard.value(forKey: key) as? Int else {
            saveProgress()
            return
        }
        self.currentProgress = progress
        print("Progress load called with value of \(progress)")
    }
}
