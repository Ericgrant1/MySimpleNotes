//
//  NotesStorage.swift
//  MySimpleNotes
//
//  Created by Eric Grant on 30.09.2021.
//

import CoreData

class NotesStorage {
    
    static let storage: NotesStorage = NotesStorage()
    
    private var noteIndexToId: [Int: UUID] = [:]
    private var currentIndex: Int = 0

    private(set) var managedObjectContext: NSManagedObjectContext
    private var managedContextSet: Bool = false
    
    private init() {
        // Init the managed object context (to be overwritten by view controller)
        managedObjectContext = NSManagedObjectContext(
            concurrencyType: NSManagedObjectContextConcurrencyType.mainQueueConcurrencyType)
    }
    
    func addNote(noteAdded: NotesModel) {
        if managedContextSet {
            noteIndexToId[currentIndex] = noteAdded.noteId
            NotesCoreData.makeNoteCoreData(noteCreated: noteAdded, inManagedObjectContext: self.managedObjectContext)
            currentIndex += 1
        }
    }
    
    func readNote(index: Int) -> NotesModel? {
        if managedContextSet {
            if index < 0 || index > currentIndex - 1 {
                return nil
            }
            
            let noteUUID = noteIndexToId[index]
            let noteReadCoreData: NotesModel?
            noteReadCoreData = NotesCoreData.readNoteCoreData(readNoteId: noteUUID!, fromManagedObjectContext: self.managedObjectContext)
            return noteReadCoreData
        }
        return nil
    }
    
}

