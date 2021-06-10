//
//  RealmRecords.swift
//  I Knew It!
//
//  Created by Тимур Таймасов on 10.06.2021.
//

import RealmSwift

class RealmRecords {
    
    // MARK: - Records
    
    /// Function that saves and updates movies data in Realm DB
    /// - Parameter movies: Array of MovieModel
    static func saveMoviesData(movies: [MovieModel]) {
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(movies, update: .all)
            }
        } catch {
            print("Realm Error: ", error.localizedDescription)
        }
    }
}
