//
//  NotesCoreData.swift
//  MySimpleNotes
//
//  Created by Eric Grant on 01.10.2021.
//

import Foundation
import CoreData

class NotesCoreData {
    
    private(set) static var count: Int = 0
    
    static func makeNoteCoreData(noteCreated: NotesModel, inManagedObjectContext: NSManagedObjectContext) {
        
        let noteEntities = NSEntityDescription.entity(forEntityName: "Note", in: inManagedObjectContext)!
        let newNotes = NSManagedObject(entity: noteEntities, insertInto: inManagedObjectContext)
        newNotes.setValue(noteCreated.noteId, forKey: "noteId")
        newNotes.setValue(noteCreated.noteTitle, forKey: "noteTitle")
        newNotes.setValue(noteCreated.noteText, forKey: "noteText")
        newNotes.setValue(noteCreated.noteNew, forKey: "noteNew")
        newNotes.setValue(noteCreated.noteEdit, forKey: "noteEdit")
        newNotes.setValue(noteCreated.noteCategory, forKey: "noteCategory")
        
        do {
            try inManagedObjectContext.save()
            count += 1
        } catch let error as NSError {
            print("Could not save object. \(error), \(error.userInfo)")
        }
    }
}
