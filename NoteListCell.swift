//
//  NoteListCell.swift
//  SmartNotepad
//
//  Created by Abdelrahman Hussein on 19/06/2021.
//

import UIKit

class NoteListCell: UITableViewCell {
    
    //MARK:- Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var locationImage: UIImageView!
    @IBOutlet weak var photoImage: UIImageView!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: true)
        self.selectionStyle = .none
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = ""
        bodyLabel.text = ""
    }
    
    var noteListCellViewModel: NoteListCellViewModel? {
        didSet {
            guard let nearest = noteListCellViewModel?.nearest else { fatalError("Can not happen") }
            guard let hasLocation = noteListCellViewModel?.hasLocation else { fatalError("Can not happen") }
            guard let hasPhoto = noteListCellViewModel?.hasPhoto else { fatalError("Can not happen") }
            locationLabel.isHidden = !nearest
            titleLabel.text = noteListCellViewModel?.title
            bodyLabel.text = noteListCellViewModel?.body
            if hasPhoto {
                photoImage.tintColor = "BCB454".toUIColor
            } else {
                photoImage.tintColor = .white
            }
            if hasLocation {
                if #available(iOS 13.0, *) {
                    locationImage.tintColor = .link
                } else {
                    // Fallback on earlier versions
                    locationImage.tintColor = .blue
                }
            } else {
                locationImage.tintColor = .white
            }
        }
    }
}
