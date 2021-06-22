//
//  GenericTableView.swift
//  SmartNotepad
//
//  Created by Abdelrahman Hussein on 19/06/2021.
//

import UIKit

class GenericTableView<Item, Cell: UITableViewCell>: UITableView, UITableViewDataSource, UITableViewDelegate {
    //MARK:- Properties
    var items: [Item]
    var config: (Item, Cell) -> Void
    var didSelectHandler: (() -> ())?
    var willSelectHandler: ((Int) -> Void)?
    var deleteHandler: ((Int) -> Void)?
    //MARK:- Initializer
    init(frame: CGRect, items: [Item], config: @escaping (Item, Cell) -> Void, didSelectHandler: (() -> ())?, willSelectHandler: ((Int) -> Void)?, deleteHandler: ((Int) -> Void)?) {
        self.items = items
        self.config = config
        self.didSelectHandler = didSelectHandler
        self.willSelectHandler = willSelectHandler
        self.deleteHandler = deleteHandler
        super.init(frame: frame, style: .plain)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.dataSource = self
        self.delegate = self
        self.registerNib()
        self.tableFooterView = UIView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK:- DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.dequeue()
        config(items[indexPath.row], cell)
        return cell
    }
    //MARK:- Delegation
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelectHandler?()
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        willSelectHandler?(indexPath.row)
        return indexPath
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteHandler?(indexPath.row)
        }
    }
}

//MARK:- Reload Table
extension GenericTableView {
    func reloadTable(data items: [Item]) {
        self.items = items
        self.reloadData()
    }
}
