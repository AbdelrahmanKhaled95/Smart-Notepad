//
//  Note.swift
//  SmartNotepad
//
//  Created by Abdelrahman Hussein on 19/06/2021.
//

import Foundation
import RealmSwift

@objcMembers class Note: Object {
    dynamic var _id: ObjectId = ObjectId.generate()
    dynamic var title: String = ""
    dynamic var body: String = ""
    dynamic var date: Date = Date()
    dynamic var latitude: String?
    dynamic var longitude: String?
    dynamic var photo: String?
    dynamic var hasPhoto: Bool = false
    dynamic var hasLocation: Bool = false
    dynamic var nearest: Bool = false
    
    override static func primaryKey() -> String? {
        return "_id"
    }
    
    convenience init(title: String, body: String, latitude: Double?, longitude: Double?, photo: String?, hasPhoto: Bool, hasLocation: Bool, nearest: Bool) {
        self.init()
        self.title = title
        self.body = body
        self.latitude = "\(latitude ?? 0)"
        self.longitude = "\(longitude ?? 0)"
        self.photo = photo
        self.hasPhoto = hasPhoto
        self.hasLocation = hasLocation
        self.nearest = nearest
    }
}
