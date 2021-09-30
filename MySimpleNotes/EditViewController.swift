//
//  EditViewController.swift
//  MySimpleNotes
//
//  Created by Eric Grant on 30.09.2021.
//

import UIKit

class EditViewController: UIViewController,  UIPickerViewDelegate, UIPickerViewDataSource {
    
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
        
        let backButton = UIBarButtonItem()
        backButton.title = "Back"
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        
        self.editCategoryPicker.isHidden = true
    }
    
    @IBAction func editNoteTitle(_ sender: UITextField) {
    }
    
    @IBAction func editNoteCategory(_ sender: UITextField) {
        self.editCategoryPicker.isHidden = false
        self.editCategoryPicker.layer.cornerRadius = 4
        self.editCategoryPicker.layer.backgroundColor = UIColor(red: 0.93, green: 0.93, blue: 0.93, alpha: 0.8).cgColor
    }
    
    @IBAction func doneButton(_ sender: UIButton) {
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
    
}
