//
//  MovieModel.swift
//  I Knew It!
//
//  Created by Тимур Таймасов on 10.06.2021.
//

import Foundation
import RealmSwift
import SwiftyJSON

/// Realm-Ready Model that represents a movie object
class MovieModel: Object {
    
    // MARK: - Variables
    
    @objc dynamic var id: String = ""
    @objc dynamic var title: String = ""
    @objc dynamic var overview: String = ""
    @objc dynamic var posterPath: String = ""
    
    var similar = List<String>()
    
    // MARK: - Initialization
    
    convenience init(json: JSON) {
        self.init()
        
        self.id = json["id"].stringValue
        self.title = json["title"].stringValue
        self.overview = json["overview"].stringValue
        self.posterPath = json["poster_path"].stringValue
    }
    
    @objc open override class func primaryKey() -> String? {
        return "id"
    }
}
