//
//  Constants.swift
//  I Knew It!
//
//  Created by Тимур Таймасов on 06.06.2021.
//

import UIKit

// MARK: - App Language
var appLanguage: String {
    switch Locale.current.languageCode {
        case "ru":
            return "ru"
        default:
            return "en"
    }
}

// MARK: - App Color Palette
enum Colors {
    static let purple = UIColor(red: 0.412, green: 0.475, blue: 0.973, alpha: 1)
    static let purpleShadow = UIColor(red: 0.196, green: 0.196, blue: 0.279, alpha: 0.06)
    static let white = UIColor.white
    static let black = UIColor.black
    static let mainBackground = UIColor(red: 0.082, green: 0.082, blue: 0.133, alpha: 1)
}

// MARK: - App Fonts
enum Fonts {
    static let SFProDisplayNormal = UIFont(name: "SFProDisplay-Regular", size: 16)
    static let SFProDisplayLight = UIFont(name: "SFProDisplay-Light", size: 16)
    static let SFProDisplaySemiBold = UIFont(name: "SFProDisplay-Semibold", size: 16)
    static let SFProTextNormal = UIFont(name: "SFProText-Regular", size: 16)
    static let SFProTextLight = UIFont(name: "SFProText-Light", size: 16)
    static let SFProTextSemiBold = UIFont(name: "SFProText-Semibold", size: 16)
}

// MARK: - Segue Identifiers
enum Segues {
    static let toQuiz = "toQuiz"
}

// MARK: - API Constants
enum API {
    static let key = "16c7ddad75e756a3870e3bd2da20776b"
    static var language: String {
        return "\(appLanguage)-\(appLanguage)"
    }
}

