//
//  NoteListViewModel.swift
//  SmartNotepad
//
//  Created by Abdelrahman Hussein on 19/06/2021.
//

import Foundation
import RealmSwift
import CoreLocation

class NoteListViewModel: BaseViewModel {
    
    //MARK:- Properties
    let realm = try! Realm()
    private var noteList: Results<Note>?
    var selectedNote: Note?
    var nearestLocationNoteIndex: Int?
    private var realmNotifier: NotificationToken!
    var noteListCellViewModel = [NoteListCellViewModel]() {
        didSet {
            self.reloadTableView?()
        }
    }
    
    
    override func updateNearestNote() {
        super.updateNearestNote()
        getNearestLocationNoteIndex()
        self.getEachNote()
    }
    
    //MARK:- Observe live objects
    func observeNoteListUpdates() {
        guard let noteList = noteList else { return }
        realmNotifier = noteList.observe({ [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .error(let error):
                self.state = .error
                self.errorMessage = error.localizedDescription
            case .initial, .update(_, _, _, _):
                self.getCurrentLocation()
                self.getNearestLocationNoteIndex()
                self.getEachNote()
            }
        })
    }
    
    //MARK:- Binding Closures
    var reloadTableView: (()->())?
    
    //MARK:- Fetch Notes
    //Step 1: Fetch all notes from Realm DB
    func fetchNotes() {
        self.state = .loading
        self.getCurrentLocation()
        self.noteList = realm.objects(Note.self).sorted(byKeyPath: "date", ascending: false)
        observeNoteListUpdates()  // Listen to Realm Live Objects
    }
    //Step 2: get nearest note location
    func getNearestLocationNoteIndex() {
        guard let noteList = noteList else { return }
        var nearwstLocationDict: [Int: CLLocation?] = [:]
        for (index, note) in noteList.enumerated() {
            
            if let latitude = note.latitude, let longitude = note.longitude {
                nearwstLocationDict[index] = CLLocation(latitude: Double(latitude) ?? 0.0, longitude: Double(longitude) ?? 0.0)
            } else {
                nearwstLocationDict[index] = nil
            }
        }
        nearestLocationNoteIndex = nearestLocation(locations: nearwstLocationDict)
    }
    //Step 3: Loop over each note
    func getEachNote() {
        guard self.noteList?.count ?? 0 > 0 else {
            state = .empty
            return
        }
        guard let noteList = noteList else { return }
        var noteCellListTemp = [NoteListCellViewModel]()
        for (index, note) in noteList.enumerated() {
            if index != nearestLocationNoteIndex {
                noteCellListTemp.append(generateNoteCell(note: note, nearest: false))
            } else {
                noteCellListTemp.insert(generateNoteCell(note: note, nearest: true), at: 0)
            }
        }
        self.state = .filled
        self.noteListCellViewModel = noteCellListTemp
    }
    //Step 4: Generate cell View model
    func generateNoteCell(note: Note, nearest: Bool) -> NoteListCellViewModel {
        return NoteListCellViewModel(title: note.title, body: note.body, nearest: nearest, hasPhoto: note.hasPhoto, hasLocation: note.hasLocation)
    }
    
    //MARK:- Delete a note
    func deleteNote(index: Int) {
        guard let noteList = self.noteList else { return }
        let note = noteList[index]
        do {
            try realm.write {
                realm.delete(note)
            }
        } catch(let error) {
            state = .error
            errorMessage = error.localizedDescription
        }
        
    }
    
    func notePressed(index: Int) {
        self.selectedNote = self.noteList?[index]
    }
    
    func loadImageFromDocumentDirectory(fileName: String) -> UIImage? {
        let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!;
        let fileURL = documentsUrl.appendingPathComponent(fileName)
        do {
            let imageData = try Data(contentsOf: fileURL)
            return UIImage(data: imageData)
        } catch(let error) {
            state = .error
            errorMessage = error.localizedDescription
        }
        return nil
    }
    
    //MARK:- Filtration
    // Find nearest location
    func nearestLocation(locations: [Int: CLLocation?]) -> Int? {
        guard locations.count > 0 else { return nil}
        guard let userLocation = userLocation else {
            errorMessage = "Location Access is denied, cannot calculate nearest note location"
            return nil
        }
        var nearestNoteIndex = 0
        var shortestDistance: CLLocationDistance?
        
        for (index, location) in locations {
            guard let location = location else { continue }
            let distance = userLocation.distance(from: location)
            if shortestDistance == nil || distance < shortestDistance! {
                shortestDistance = distance
                nearestNoteIndex = index
            }
        }
        return nearestNoteIndex
    }
}
