//
//  DetailViewController.swift
//  MySimpleNotes
//
//  Created by Eric Grant on 30.09.2021.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var detailTitleLabel: UILabel!
    @IBOutlet weak var detailCategoryLabel: UILabel!
    @IBOutlet weak var detailDateLabel: UILabel!
    @IBOutlet weak var detailNoteTextView: UITextView!
    @IBOutlet weak var detailEditButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        
        detailEditButton.layer.cornerRadius = 5
        detailEditButton.layer.borderWidth = 2
        detailEditButton.layer.borderColor = UIColor.systemBlue.cgColor
    }
    
    func setupView() {
        if let detail = detailItem {
            if let titleLabel = detailTitleLabel,
               let dateLabel = detailDateLabel,
               let categoryLabel = detailCategoryLabel,
               let textView = detailNoteTextView {
                titleLabel.text = detail.noteTitle
                categoryLabel.text = detail.noteCategory
                dateLabel.text = "Created " + "  |  Last modified "
                textView.attributedText = detail.noteText
            }
        }
    }
    
    var detailItem: NotesModel? {
        didSet {
            setupView()
        }
    }
}
