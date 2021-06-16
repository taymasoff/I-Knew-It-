//
//  AppSettings.swift
//  I Knew It!
//
//  Created by Тимур Таймасов on 16.06.2021.
//

import Foundation


// MARK: - App Difficulty
enum Difficulty {
    case easy
    case medium
    case hard
}

// MARK: - Application Settings
struct AppSettings {
    
    // MARK: - Singleton
    static let shared = AppSettings()
    
    // MARK: - Difficulty level
    var difficulty: Difficulty {
        // TODO: Add difficulty level choice
        return .easy
    }
    
    // MARK: - App Language
    var appLanguage: String {
        switch Locale.current.languageCode {
            case "ru":
                return "ru"
            default:
                return "en"
        }
    }
}
