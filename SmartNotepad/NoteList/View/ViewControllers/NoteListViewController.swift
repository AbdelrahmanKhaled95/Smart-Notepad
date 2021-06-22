//
//  NoteListViewController.swift
//  SmartNotepad
//
//  Created by Abdelrahman Hussein on 19/06/2021.
//

import UIKit

class NoteListViewController: BaseViewController {
    
    //MARK:- Outlets
    @IBOutlet weak var activitySpinner: UIActivityIndicatorView!
    @IBOutlet weak var addButton: UIButton!
    //MARK:-Properties
    var genericTableView: GenericTableView<NoteListCellViewModel, NoteListCell>?
    var viewModel: NoteListViewModel = {
        return NoteListViewModel()
    }()
    //MARK:- ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Notes"
        addButtonSetup()
        setupGenericTableView()
        setupBinding()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        viewModel.getCurrentLocation()
    }
    //MARK:- Actions
    @IBAction func addNewNote(_ sender: Any) {
        self.activitySpinner.startAnimating()
        self.activitySpinner.isHidden = false
        let storyboard = UIStoryboard(name: "NoteDetails", bundle: nil)
        let noteDetailsVC = storyboard.instantiateInitialViewController() as! NoteDetailsViewController
        self.navigationController?.pushViewController(noteDetailsVC, animated: true)
    }
    
    func addButtonSetup() {
        addButton.layer.masksToBounds = true
        addButton.layer.cornerRadius = 8
        addButton.layer.borderColor = UIColor.black.cgColor
        addButton.layer.borderWidth = 2
    }
    
    func setupGenericTableView() {
        genericTableView = GenericTableView(frame: self.view.frame, items: viewModel.noteListCellViewModel, config: configNoteTable, didSelectHandler: didSelectHelper, willSelectHandler: willSelectHelper(index:) , deleteHandler: deleteHelper(index:))
        if let genericTableView = genericTableView {
            self.view.addSubview(genericTableView)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
