//
//  NotesViewController.swift
//  MySimpleNotes
//
//  Created by Eric Grant on 29.09.2021.
//

import UIKit
import CoreData

class NotesViewController: UITableViewController {
    
    var detailVC: DetailViewController? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            let alert = UIAlertController(title: "Could note get app delegate",
                                          message: "Could note get app delegate, unexpected error occurred. Try again later.",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        NotesStorage.storage.setManagedContext(managedObjectContext: managedContext)
        
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
        performSegue(withIdentifier: "showNewNoteSegue", sender: self)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return NotesStorage.storage.count()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! NoteCellController
        if let object = NotesStorage.storage.readNote(index: indexPath.row) {
            cell.noteTitleLabel.text = object.noteTitle
            cell.noteTextLabel.attributedText = object.noteText
            cell.noteCategoryLabel.text = object.noteCategory
            cell.noteDateLabel.text = DateForNote.convertDate(date: Date.init(minutes: object.noteEdit))
        }
        cell.backgroundColor = UIColor.clear
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
        } else if editingStyle == .insert {

        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let object = NotesStorage.storage.readNote(index: indexPath.row)
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.detailItem = object
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }
}
