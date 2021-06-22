//
//  NoteDetailsViewController.swift
//  SmartNotepad
//
//  Created by Abdelrahman Hussein on 20/06/2021.
//

import UIKit

class NoteDetailsViewController: BaseViewController {
    
    //MARK:- Outlets
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var bodyTextView: UITextView!
    @IBOutlet weak var locationImageView: UIImageView!
    @IBOutlet weak var addLocationButton: UIButton!
    @IBOutlet weak var addPhotoImageView: UIImageView!
    @IBOutlet weak var addPhotoButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var activitySpinner: UIActivityIndicatorView!
    @IBOutlet weak var noteImageView: UIImageView!
    
    //MARK:- Properties
    lazy var viewModel: NoteDetailsViewModel = {
        return NoteDetailsViewModel()
    }()
    var pickerController = UIImagePickerController()
    var imageView = UIImage()
    var imageNameURL: String?
    var editNote: Bool = false
    var noteID: String = ""
    var noteTitle = ""
    var body = ""
    var latitude:String?
    var longitude: String?
    var noteImage: UIImage?
    
    //MARK:- ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        addGesturesForImages()
        setupBinding()
        if editNote {
            fillNote()
        }
    }
    //MARK:- UI Setup
    func addGesturesForImages() {
        let locationImageViewTapGesture = UITapGestureRecognizer(target: self, action: #selector(addLocation(_:)))
        locationImageView.isUserInteractionEnabled = true
        locationImageView.addGestureRecognizer(locationImageViewTapGesture)
        let photoImageViewTapGesture = UITapGestureRecognizer(target: self, action: #selector(addPhoto(_:)))
        addPhotoImageView.addGestureRecognizer(photoImageViewTapGesture)
        addPhotoImageView.isUserInteractionEnabled = true
        noteImageView.isUserInteractionEnabled = true
        noteImageView.addGestureRecognizer(photoImageViewTapGesture)
    }
    func setupUI() {
        deleteButton.isHidden = true
        titleTextField.placeholder = "Note Title Here"
        bodyTextView.text = "Note Body Here"
        bodyTextView.textColor = UIColor.lightGray
        bodyTextView.delegate  = self
        addPhotoButton.titleLabel?.textColor = .lightGray
        noteImageView.isHidden = true
        let camera = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(createNote))
        self.navigationItem.rightBarButtonItem = camera
    }
    
    @objc func createNote() {
        if editNote {
            viewModel.editNote(id: noteID, title: titleTextField.text, body: bodyTextView.text, image: imageNameURL)
        } else {
            viewModel.createNote(title: titleTextField.text, body: bodyTextView.text, image: imageNameURL)
        }
    }
    
    
    func fillNote() {
        deleteButton.isHidden = false
        titleTextField.text = noteTitle
        bodyTextView.text = body
        if let latitude = latitude, let longitude = longitude {
            viewModel.fetchLocation(latitude: latitude, longitude: longitude)
        }
        if let noteImage = noteImage {
            addPhotoButton.isHidden = true
            noteImageView.isHidden = false
            noteImageView.image = noteImage
        }
    }
    
    //MARK:- Actions
    @IBAction func addLocation(_ sender: Any) {
        viewModel.getCurrentLocation()
    }
    
    @IBAction func addPhoto(_ sender: Any) {
        uploadPhoto()
    }
    
    @IBAction func deleteNote(_ sender: Any) {
        viewModel.deleteNote(id: noteID)
    }
    
}
