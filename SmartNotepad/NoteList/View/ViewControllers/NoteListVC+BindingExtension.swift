//
//  NoteListVC+BindingExtension.swift
//  SmartNotepad
//
//  Created by Abdelrahman Hussein on 19/06/2021.
//

import UIKit

//MARK:- Setup binding
extension NoteListViewController {
    func setupBinding() {
        viewModel.showAlert = { [weak self] () in
            guard let self = self else { return }
            DispatchQueue.main.async {[weak self] in
                guard let self = self else { return }
                if let message = self.viewModel.errorMessage {
                    self.showAlert(message)
                    self.genericTableView?.setEmptyMessage(message)
                }
            }
        }
        viewModel.updateLoadingStatus = { [weak self] () in
            guard let self = self else { return }
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                switch self.viewModel.state {
                case .empty, .error:
                    self.activitySpinner.stopAnimating()
                    UIView.animate(withDuration: 0.1, animations: {
                        self.activitySpinner.isHidden = true
                        self.genericTableView?.isHidden = true
                    })
                case .loading:
                    self.activitySpinner.startAnimating()
                    UIView.animate(withDuration: 0.1, animations: {
                        self.activitySpinner.isHidden = false
                        self.genericTableView?.isHidden = true
                    })
                case .filled:
                    self.activitySpinner.stopAnimating()
                    UIView.animate(withDuration: 0.1, animations: {
                        self.genericTableView?.restore()
                        self.genericTableView?.isHidden = false
                        self.activitySpinner.isHidden = true
                    })
                }
            }
        }
        viewModel.reloadTableView = { [weak self] () in
            guard let self = self else { return }
            guard let genericTableView = self.genericTableView else { return }
            genericTableView.reloadTable(data: self.viewModel.noteListCellViewModel)
        }
        viewModel.fetchNotes()
    }
}

