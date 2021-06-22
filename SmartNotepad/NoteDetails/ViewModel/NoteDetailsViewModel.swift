//
//  NoteDetailsViewModel.swift
//  SmartNotepad
//
//  Created by Abdelrahman Hussein on 20/06/2021.
//

import Foundation
import RealmSwift

class NoteDetailsViewModel: BaseViewModel {
    
    //MARK:- Properties
    lazy var realm = {
        return try! Realm()
    }()
    
    //MARK:- Binding Closures
    var noteUpdated: (() -> ())?
    
    //MARK:- Create New Note
    func createNote(title: String?, body: String?, image: String?) {
        guard validateNote(title: title, body: body) else { return }
        var hasLocation = false
        var hasPhoto = false
        if let _ = latitude, let _ = longitude {
            hasLocation = true
        }
        if let _ = image {
            hasPhoto = true
        }
        do {
            print(realm.configuration.fileURL)
            try realm.write {
                realm.add(Note(title: title!, body: body!, latitude: latitude ?? nil, longitude: longitude ?? nil, photo: image ?? nil, hasPhoto: hasPhoto, hasLocation: hasLocation, nearest: false))
                noteUpdated?()
            }
        } catch(let error) {
            self.state = .error
            self.errorMessage = error.localizedDescription
        }
    }
    
    func validateNote(title: String?, body: String?) -> Bool {
        guard let title = title, title.trimmingCharacters(in: .whitespacesAndNewlines) != "" else {
            state = .error
            errorMessage = "Please, add a title"
            return false
        }
        guard let body = body, body.trimmingCharacters(in: .whitespacesAndNewlines) != "" else {
            state = .error
            errorMessage = "Please, add a description"
            return false
        }
        return true
    }
    
    //MARK:- Edit Note
    func editNote(id: String, title: String?, body: String?, image: String?) {
        guard validateNote(title: title, body: body) else { return }
        var hasLocation = false
        var hasPhoto = false
        if let _ = latitude, let _ = longitude {
            hasLocation = true
        }
        if let _ = image {
            hasPhoto = true
        }
        do {
            let stringID = try ObjectId(string: id)
            let note = realm.object(ofType: Note.self, forPrimaryKey: stringID)
            try realm.write {
                note?.title = title ?? ""
                note?.body = body ?? ""
                note?.latitude = "\(latitude ?? 0.0)"
                note?.longitude = "\(longitude ?? 0.0)"
                note?.photo = image
                note?.hasPhoto = hasPhoto
                note?.hasLocation = hasLocation
                noteUpdated?()
            }
        } catch(let error) {
            self.state = .error
            self.errorMessage = error.localizedDescription
        }
    }
    //MARK:- Delete Note
    func deleteNote(id: String) {
        do {
            let stringID = try ObjectId(string: id)
            let note = realm.object(ofType: Note.self, forPrimaryKey: stringID)
            guard let note = note else { return }
            try realm.write {
                realm.delete(note)
                noteUpdated?()
            }
        } catch(let error) {
            self.state = .error
            self.errorMessage = error.localizedDescription
        }
    }
}
