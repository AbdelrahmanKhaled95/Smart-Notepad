//
//  NoteDetailsVC+Binding.swift
//  SmartNotepad
//
//  Created by Abdelrahman Hussein on 20/06/2021.
//

import UIKit

//MARK:- Setup binding
extension NoteDetailsViewController {
    
    func setupBinding() {
        viewModel.showAlert = { [weak self] () in
            guard let self = self else { return }
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                if let message = self.viewModel.errorMessage {
                    self.showAlert(message)
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
                    })
                case .loading:
                    self.activitySpinner.startAnimating()
                    UIView.animate(withDuration: 0.1, animations: {
                        self.activitySpinner.isHidden = false
                    })
                case .filled:
                    self.activitySpinner.stopAnimating()
                    UIView.animate(withDuration: 0.1, animations: {
                        self.activitySpinner.isHidden = true
                    })
                }
            }
        }
        
        viewModel.rejectLocationAccess = { [weak self] in
            guard let self = self else {return}
            let alert = UIAlertController(title: "Location Permission Required", message: "Please enable location permissions in settings.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) { _ in
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    if UIApplication.shared.canOpenURL(url) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    }
                }
            }
            alert.addAction(okAction)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

            self.present(alert, animated: true, completion: nil)
        }
        
        viewModel.setLocation = { [weak self] (location) in
            guard let self = self else { return }
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.addLocationButton.setTitle(location, for: .normal)
                self.addLocationButton.titleLabel?.textColor = .black
                self.addLocationButton.setTitleColor(.black, for: .normal)
            }
        }
        
        viewModel.noteUpdated = {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}

