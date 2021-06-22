//
//  NoteDetailsVC+UITextViewDelegate.swift
//  SmartNotepad
//
//  Created by Abdelrahman Hussein on 20/06/2021.
//

import UIKit

extension NoteDetailsViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Note Body Here"
            textView.textColor = UIColor.lightGray
        }
    }
}
