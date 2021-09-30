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
    }
}
