//
//  EditViewController.swift
//  MySimpleNotes
//
//  Created by Eric Grant on 30.09.2021.
//

import UIKit

class EditViewController: UIViewController,  UIPickerViewDelegate, UIPickerViewDataSource, UITextViewDelegate {
    
    private let timeOfNoteCreation: Int64 = Date().toMinutes()
    private let timeOfNoteModification: Int64 = Date().toMinutes()
    
    private(set) var editingNote: NotesModel?

    var listOfCategories = ["Education", "Ideas", "Information", "Inspiration", "Lists", "Personal", "Recipes", "Reminders", "Work", "Other"]
    
    @IBOutlet weak var editDateLabel: UILabel!
    @IBOutlet weak var editTitleTextField: UITextField!
    @IBOutlet weak var editCategoryTextField: UITextField!
    @IBOutlet weak var editCategoryPicker: UIPickerView!
    @IBOutlet weak var editTextView: UITextView!
    @IBOutlet weak var editDoneButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        editTextView.delegate = self
        editTextView.font = UIFont(name: "Menlo", size: 15.0)
        editTextView.layer.borderColor = UIColor(red: 0.89, green: 0.89, blue: 0.89, alpha: 1.0).cgColor
        editTextView.layer.borderWidth = 1.0
        editTextView.layer.cornerRadius = 5
        
        editDoneButton.layer.cornerRadius = 6
        
        let backButton = UIBarButtonItem()
        backButton.title = "Back"
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        
        self.editCategoryPicker.isHidden = true
        
        if let editingNote = self.editingNote {
            editDateLabel.text = DateForNote.convertDate(date: Date.init(minutes: timeOfNoteCreation))
            editTextView.attributedText = editingNote.noteText
            editTitleTextField.text = editingNote.noteTitle
            editCategoryTextField.text = editingNote.noteCategory
            
            editDoneButton.isEnabled = true
            editDoneButton.layer.borderWidth = 3
            editDoneButton.layer.borderColor = UIColor.systemBlue.cgColor
        } else {
            editDateLabel.text = DateForNote.convertDate(date: Date.init(minutes: timeOfNoteCreation))
        }
    }
    
    @IBAction func editNoteTitle(_ sender: UITextField, forEvent event: UIEvent) {
        if self.editingNote != nil {
            editDoneButton.isEnabled = true
        } else {
            if (sender.text?.isEmpty ?? true) || (editTextView.text?.isEmpty ?? true ) {
                editDoneButton.isEnabled = false
            } else {
                editDoneButton.isEnabled = true
            }
        }
    }
    
    @IBAction func editNoteCategory(_ sender: UITextField) {
        self.editCategoryPicker.isHidden = false
        self.editCategoryPicker.layer.cornerRadius = 4
        self.editCategoryPicker.layer.backgroundColor = UIColor(red: 0.93, green: 0.93, blue: 0.93, alpha: 0.8).cgColor
    }
    
    @IBAction func doneButton(_ sender: UIButton, forEvent event: UIEvent) {
        if self.editingNote != nil {
            editNoteItem()
        } else {
            addNoteItem()
        }
    }
    
    func setEditingNote(editingNote: NotesModel) {
        self.editingNote = editingNote
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return listOfCategories.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        self.view.endEditing(true)
        return listOfCategories[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.editCategoryTextField.text = self.listOfCategories[row]
        self.editCategoryPicker.isHidden = true
    }
    
    private func addNoteItem() -> Void {
        let newNote = NotesModel(noteTitle: editTitleTextField.text!,
                                 noteText: editTextView.attributedText,
                                 noteNew: timeOfNoteCreation,
                                 noteEdit: timeOfNoteModification,
                                 noteCategory: editCategoryTextField.text!)
        
        NotesStorage.storage.addNote(noteAdded: newNote)
        
        performSegue(withIdentifier: "backToNotesView", sender: self)
    }
    
    private func editNoteItem() -> Void {
        if let editingNote = self.editingNote {
            NotesStorage.storage.editNote(
                noteEdited: NotesModel(noteId: editingNote.noteId,
                                       noteTitle: editTitleTextField.text!,
                                       noteText: editTextView.attributedText,
                                       noteNew: timeOfNoteCreation,
                                       noteEdit: timeOfNoteModification,
                                       noteCategory: editCategoryTextField.text!)
            )
            performSegue(withIdentifier: "backToNotesView", sender: self)
        } else {
            let alert = UIAlertController(title: "Unexpected error",
                                          message: "Cannot change the note, unexpected error occurred. Try again later.",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                self.performSegue(withIdentifier: "backToNotesView", sender: self)
            }))
            self.present(alert, animated: true)
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if self.editingNote != nil {
            editDoneButton.isEnabled = true
        } else {
            if (editTitleTextField.text?.isEmpty ?? true) ||
                (editCategoryTextField.text?.isEmpty ?? true) ||
                (textView.text?.isEmpty ?? true) {
                editDoneButton.isEnabled = false
            } else {
                editDoneButton.isEnabled = true
                editDoneButton.layer.borderWidth = 3
                editDoneButton.layer.borderColor = UIColor.systemBlue.cgColor
            }
        }
    }
}
