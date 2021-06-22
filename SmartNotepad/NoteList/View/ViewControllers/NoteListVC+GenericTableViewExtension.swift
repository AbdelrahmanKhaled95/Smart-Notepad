//
//  NoteListVC+GenericTableViewExtension.swift
//  SmartNotepad
//
//  Created by Abdelrahman Hussein on 19/06/2021.
//

import UIKit

//MARK:- Generic TableView closures
extension NoteListViewController {
    func configNoteTable(item: NoteListCellViewModel, cell: NoteListCell) {
        cell.noteListCellViewModel = item
    }
    
    func didSelectHelper() {
        let storyboard = UIStoryboard(name: "NoteDetails", bundle: nil)
        let noteDetailsVC = storyboard.instantiateInitialViewController() as! NoteDetailsViewController
        let note = viewModel.selectedNote
        guard let note = note else { fatalError("Can not happen") }
        noteDetailsVC.editNote = true
        noteDetailsVC.noteTitle = note.title
        noteDetailsVC.body = note.body
        noteDetailsVC.latitude = note.latitude
        noteDetailsVC.longitude = note.longitude
        noteDetailsVC.noteID = note._id.stringValue
        if let imagePath = note.photo {
            noteDetailsVC.noteImage = viewModel.loadImageFromDocumentDirectory(fileName: imagePath)
            
        }
        self.navigationController?.pushViewController(noteDetailsVC, animated: true)
    }
    
    func willSelectHelper(index: Int) {
        self.viewModel.notePressed(index: index)
    }
    
    func deleteHelper(index: Int) {
        viewModel.deleteNote(index: index)
    }
}
