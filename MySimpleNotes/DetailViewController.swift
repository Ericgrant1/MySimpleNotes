//
//  DetailViewController.swift
//  MySimpleNotes
//
//  Created by Eric Grant on 30.09.2021.
//

import UIKit

class DetailViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var detailTitleLabel: UILabel!
    @IBOutlet weak var detailCategoryLabel: UILabel!
    @IBOutlet weak var detailDateLabel: UILabel!
    @IBOutlet weak var detailNoteTextView: UITextView!
    @IBOutlet weak var detailEditButton: UIButton!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Выполнит какие-либо дополнительные настройки после загрузки представления, обычно из nib.
        setupView()
        // Стилизуем кнопку редактирования рамкой
        detailEditButton.layer.cornerRadius = 5
        detailEditButton.layer.borderWidth = 2
        detailEditButton.layer.borderColor = UIColor.systemBlue.cgColor
    }
    
    // MARK: - Helpers
    
    func setupView() {
        // Обновляем пользовательский интерфейс для элемента detail.
        if let detail = detailItem {
            if let titleLabel = detailTitleLabel,
               let dateLabel = detailDateLabel,
               let categoryLabel = detailCategoryLabel,
               let textView = detailNoteTextView {
                titleLabel.text = detail.noteTitle
                categoryLabel.text = detail.noteCategory
                dateLabel.text = "Created " + DateForNote.convertDate(date: Date.init(minutes: detail.noteNew)) + "  |  Last modified " + DateForNote.convertDate(date: Date.init(minutes: detail.noteEdit))
                textView.attributedText = detail.noteText
            }
        }
    }
    
    var detailItem: NotesModel? {
        didSet {
            // Обновляем представление
            setupView()
        }
    }
    
    // MARK: - Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showEditNoteSegue" {
            let editNoteViewController = segue.destination as! EditViewController
            if let detail = detailItem {
                editNoteViewController.setEditingNote(
                    editingNote: detail)
            }
        }
    }
}
