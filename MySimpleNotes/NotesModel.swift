//
//  NotesModel.swift
//  MySimpleNotes
//
//  Created by Eric Grant on 30.09.2021.
//

import Foundation

class NotesModel {
    
    private(set) var noteId: UUID
    private(set) var noteTitle: String
    private(set) var noteText: NSAttributedString
    private(set) var noteNew: Int64
    private(set) var noteEdit: Int64
    private(set) var noteCategory: String
    
    init(noteTitle: String, noteText: NSAttributedString, noteNew: Int64, noteEdit: Int64, noteCategory: String) {
        self.noteId = UUID()
        self.noteTitle = noteTitle
        self.noteText = noteText
        self.noteNew = noteNew
        self.noteEdit = noteEdit
        self.noteCategory = noteCategory
    }

    init(noteId: UUID, noteTitle: String, noteText: NSAttributedString, noteNew: Int64, noteEdit: Int64, noteCategory: String) {
        self.noteId = noteId
        self.noteTitle = noteTitle
        self.noteText = noteText
        self.noteNew = noteNew
        self.noteEdit = noteEdit
        self.noteCategory = noteCategory
    }
}
