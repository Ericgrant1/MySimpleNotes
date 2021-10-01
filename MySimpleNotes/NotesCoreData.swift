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
    
    static func readNotesCoreData(fromManagedObjectContext: NSManagedObjectContext) -> [NotesModel] {
        
        var notesReturn = [NotesModel]()
        let notesFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Note")
        notesFetchRequest.predicate = nil
        
        do {
            let fetchedNotesCoreData = try fromManagedObjectContext.fetch(notesFetchRequest)
            fetchedNotesCoreData.forEach { (fetchRequestResult) in
                let readNoteMangedObject = fetchRequestResult as! NSManagedObject
                notesReturn.append(NotesModel.init(
                    noteId: readNoteMangedObject.value(forKey: "noteId") as! UUID,
                    noteTitle: readNoteMangedObject.value(forKey: "noteTitle") as! String,
                    noteText: readNoteMangedObject.value(forKey: "noteText") as! NSAttributedString,
                    noteNew: readNoteMangedObject.value(forKey: "noteNew") as! Int64,
                    noteEdit: readNoteMangedObject.value(forKey: "noteEdit") as! Int64,
                    noteCategory: readNoteMangedObject.value(forKey: "noteCategory") as! String)
                )
            }
        } catch let error as NSError {
            print("Could not read. \(error), \(error.userInfo)")
        }
        self.count = notesReturn.count
        return notesReturn.sorted() {
            $0.noteEdit > $1.noteEdit
        }
    }
    
    static func readNoteCoreData(readNoteId: UUID, fromManagedObjectContext: NSManagedObjectContext) -> NotesModel? {
        
        let noteFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Note")
        let noteIdPredicate = NSPredicate(format: "noteId = %@", readNoteId as CVarArg)
        noteFetchRequest.predicate = noteIdPredicate
        do {
            let fetchedNotesCoreData = try fromManagedObjectContext.fetch(noteFetchRequest)
            let readNoteMangedObject = fetchedNotesCoreData[0] as! NSManagedObject
            return NotesModel.init(noteId: readNoteMangedObject.value(forKey: "noteId") as! UUID,
                                   noteTitle: readNoteMangedObject.value(forKey: "noteTitle") as! String,
                                   noteText: readNoteMangedObject.value(forKey: "noteText") as! NSAttributedString,
                                   noteNew: readNoteMangedObject.value(forKey: "noteNew") as! Int64,
                                   noteEdit: readNoteMangedObject.value(forKey: "noteEdit") as! Int64,
                                   noteCategory: readNoteMangedObject.value(forKey: "noteCategory") as! String
            )
        } catch let error as NSError {
            print("Could not read. \(error), \(error.userInfo)")
            return nil
        }
    }
    
    static func removeNoteCoreData(deleteNoteId: UUID, fromManageObjectContext: NSManagedObjectContext) {
        
        let noteFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Note")
        let noteIdCVarArg: CVarArg = deleteNoteId as CVarArg
        let noteIdPredicate = NSPredicate(format: "noteId == %@", noteIdCVarArg)
        noteFetchRequest.predicate = noteIdPredicate
        do {
            let fetchNotesCoreData = try fromManageObjectContext.fetch(noteFetchRequest)
            let deletedNoteManageObject = fetchNotesCoreData[0] as! NSManagedObject
            fromManageObjectContext.delete(deletedNoteManageObject)
            
            do {
                try fromManageObjectContext.save()
                self.count -= 1
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        } catch let error as NSError {
            print("Could not delete. \(error), \(error.userInfo)")
        }
    }
}
