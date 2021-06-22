//
//  NoteDetailsVC+UIImagePickerVCExtension.swift
//  SmartNotepad
//
//  Created by Abdelrahman Hussein on 20/06/2021.
//

import Foundation
import UIKit
import Photos


extension NoteDetailsViewController: UINavigationControllerDelegate {
    
    func uploadPhoto() {
        let alertViewController = UIAlertController(title: "", message: "Do you want to open your Photo album ?", preferredStyle: .actionSheet)
        
        let gallery = UIAlertAction(title: "Photo album", style: .default) { (alert) in
            self.openGallary()
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (alert) in
        }
        alertViewController.addAction(gallery)
        alertViewController.addAction(cancel)
        self.present(alertViewController, animated: true, completion: nil)
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            alertViewController.popoverPresentationController?.sourceView = self.view
            alertViewController.popoverPresentationController?.sourceRect = CGRect(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2, width: 0, height: 0)
            alertViewController.popoverPresentationController?.permittedArrowDirections = [.down, .up]
        }
    }
    
    func openGallary() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.savedPhotosAlbum) {
            pickerController.delegate = self
            pickerController.sourceType = UIImagePickerController.SourceType.photoLibrary
            pickerController.allowsEditing = true
            checkPermission()
        }
    }
    
    //Display this popup in case access to photo gallery is denied
    func displayAlert() {
        let alert = UIAlertController(title: "User has denied the permission.", message: "Please allow access to photo album. in Settings", preferredStyle: .alert)
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
    
    func checkPermission() {
        let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        DispatchQueue.main.async {  [weak self] in
            guard let self = self else {return}
            switch photoAuthorizationStatus {
            case .authorized:
                self.present(self.pickerController, animated: true, completion: nil)
            case .notDetermined:
                PHPhotoLibrary.requestAuthorization({ [weak self] (newStatus) in
                    DispatchQueue.main.async {  [weak self] in
                        guard let self = self else {return}
                        if newStatus ==  PHAuthorizationStatus.authorized {
                            self.present(self.pickerController, animated: true, completion: nil)
                        } else {
                            self.displayAlert()
                        }
                    }
                })
            case .restricted, .denied:
                self.displayAlert()
            case .limited:
                break
            @unknown default:
                break
            }
        }
    }
}

extension NoteDetailsViewController: UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        imageView = info[UIImagePickerController.InfoKey.editedImage] as! UIImage
        let imageFileName = "\(titleTextField.text ?? "noteTitle")_image"
        imageNameURL = imageFileName
        saveImage(image: imageView, fileName: imageFileName)
        noteImageView.contentMode = .scaleAspectFit
        noteImageView.image = imageView
        addPhotoButton.isHidden = true
        noteImageView.isHidden = false
        dismiss(animated:true, completion: nil)
    }
    
    func saveImage(image: UIImage, fileName: String) {
        let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!;
         let fileURL = documentsUrl.appendingPathComponent(fileName)
        if let imageData = image.pngData() {
             try? imageData.write(to: fileURL, options: .atomic)
         }
     }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
