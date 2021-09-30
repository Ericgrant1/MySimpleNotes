//
//  NotesViewController.swift
//  MySimpleNotes
//
//  Created by Eric Grant on 29.09.2021.
//

import UIKit

class NotesViewController: UITableViewController {
    
    var detailVC: DetailViewController? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = editButtonItem
        
        let addNoteButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertNewNote(_:)))
        navigationItem.rightBarButtonItem = addNoteButton
        if let splitVC = splitViewController {
            let controllers = splitVC.viewControllers
            detailVC = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
        
        self.tableView.delegate = self
    }
    
    @objc func insertNewNote(_ sender: Any) {
        performSegue(withIdentifier: "showCreateNoteSegue", sender: self)
    }
}
