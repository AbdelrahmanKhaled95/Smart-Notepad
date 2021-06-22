//
//  GenericTableView+Extension.swift
//  SmartNotepad
//
//  Created by Abdelrahman Hussein on 19/06/2021.
//

import UIKit

extension GenericTableView {
    func registerNib() {
        let nibName = "\(Cell.self)"
        self.register(UINib(nibName: nibName, bundle: nil), forCellReuseIdentifier: nibName)
    }
    
    func dequeue() -> Cell {
        guard let cell = self.dequeueReusableCell(withIdentifier: "\(Cell.self)") as? Cell else { fatalError("Can't Happen") }
        return cell
    }
    
    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont(name: "TrebuchetMS", size: 15)
        messageLabel.sizeToFit()

        self.backgroundView = messageLabel
        self.separatorStyle = .none
    }

    func restore() {
        self.backgroundView = nil
        self.separatorStyle = .singleLine
    }
}

