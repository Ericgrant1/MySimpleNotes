//
//  EditViewController.swift
//  MySimpleNotes
//
//  Created by Eric Grant on 30.09.2021.
//

import UIKit

class EditViewController: UIViewController {
    
    @IBOutlet weak var editDateLabel: UILabel!
    @IBOutlet weak var editTitleTextField: UITextField!
    @IBOutlet weak var editCategoryTextField: UITextField!
    @IBOutlet weak var editCategoryPicker: UIPickerView!
    @IBOutlet weak var editTextView: UITextView!
    @IBOutlet weak var editDoneButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func editNoteTitle(_ sender: UITextField) {
    }
    
    @IBAction func editNoteCategory(_ sender: UITextField) {
    }
    
    @IBAction func doneButton(_ sender: UIButton) {
    }
    
}
