//
//  EditViewController.swift
//  MySimpleNotes
//
//  Created by Eric Grant on 30.09.2021.
//

import UIKit

class EditViewController: UIViewController,  UIPickerViewDelegate, UIPickerViewDataSource, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private let timeOfNoteCreation: Int64 = Date().toMinutes()
    private let timeOfNoteModification: Int64 = Date().toMinutes()
    
    private(set) var editingNote: NotesModel?

    var listOfCategories = ["Education", "Ideas", "Information", "Inspiration", "Lists", "Personal", "Recipes", "Reminders", "Work", "Other"]
    
    var auxiliaryDoneButton: UIBarButtonItem!
    var auxiliaryImageButton: UIBarButtonItem!
    let softBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    let noteToolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
    
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
        
        auxiliaryDoneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(handleToolbarDoneButton))
        auxiliaryImageButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.camera, target: self, action: #selector(handleToolBarImageButton))
        noteToolBar.items = [auxiliaryImageButton, softBarButton, auxiliaryDoneButton]
        editTextView.inputAccessoryView = noteToolBar
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
    
    private func showImageSelection() {
        let alert = UIAlertController(title: "Image Selection", message: "Where would you like to select the image from?", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.addImageToNote(from: .camera)
        }))
        alert.addAction(UIAlertAction(title: "Photo Album", style: .default, handler: { _ in
            self.addImageToNote(from: .photoLibrary)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func addImageToNote(from sourceType: UIImagePickerController.SourceType) {
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            let imagePC = UIImagePickerController()
            imagePC.delegate = self
            imagePC.sourceType = sourceType
            self.present(imagePC, animated: false, completion: nil)
        }
    }
    
    @objc func handleToolbarDoneButton() {
        view.endEditing(true)
    }
    
    @objc func handleToolBarImageButton() {
        self.showImageSelection()
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
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.dismiss(animated: true) {
            guard let noteImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
            let attachment = NSTextAttachment()
            attachment.image = noteImage
            let newImageWith = self.editTextView.bounds.size.width - 20
            let imageScale = newImageWith / noteImage.size.width
            let newImageHeight = noteImage.size.height * imageScale
            
            func resizeImage(image: UIImage, withSize: CGSize) -> UIImage {
                var realHeight: CGFloat = image.size.height
                var realWidth: CGFloat = image.size.width
                let maxHeight: CGFloat = withSize.height
                let maxWidth: CGFloat = withSize.width
                var imageRatio: CGFloat = realWidth / realHeight
                let maxRation: CGFloat = maxWidth / maxHeight
                let compressionQuality = 0.5
                if (realHeight > maxHeight || realWidth > maxWidth) {
                    if imageRatio < maxRation {
                        imageRatio = maxHeight / realHeight
                        realWidth = imageRatio * realWidth
                        realHeight = maxHeight
                    } else if imageRatio > maxRation {
                        imageRatio = maxWidth / realWidth
                        realHeight = imageRatio * realHeight
                        realWidth = maxWidth
                    } else {
                        realHeight = maxHeight
                        realWidth = maxWidth
                    }
                }
                let rectangle: CGRect = CGRect(x: 0.0, y: 0.0, width: realWidth, height: realHeight)
                UIGraphicsBeginImageContext(rectangle.size)
                image.draw(in: rectangle)
                let selectedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
                let imageData = selectedImage.jpegData(compressionQuality: CGFloat(compressionQuality))
                UIGraphicsEndImageContext()
                let resizedImage = UIImage(data: imageData!)
                return resizedImage!
            }
            attachment.image = resizeImage(image: attachment.image!, withSize: CGSize(width: newImageWith, height: newImageHeight))
            let currentAtString = NSMutableAttributedString(attributedString: self.editTextView.attributedText)
            let attachmentAtString = NSAttributedString(attachment: attachment)
            if let selectedRange = self.editTextView.selectedTextRange {
                let cursorIndex = self.editTextView.offset(from: self.editTextView.beginningOfDocument, to: selectedRange.start)
                currentAtString.insert(attachmentAtString, at: cursorIndex)
                currentAtString.addAttributes(self.editTextView.typingAttributes, range: NSRange(location: cursorIndex, length: 1))
            } else {
                currentAtString.append(attachmentAtString)
            }
            self.editTextView.attributedText = currentAtString
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}
