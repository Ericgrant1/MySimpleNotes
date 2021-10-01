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
    
    func setManagedContext(managedObjectContext: NSManagedObjectContext) {
        self.managedObjectContext = managedObjectContext
        self.managedContextSet = true
        let notes = NotesCoreData.readNotesCoreData(fromManagedObjectContext: self.managedObjectContext)
        currentIndex = NotesCoreData.count
        for (index, note) in notes.enumerated() {
            noteIndexToId[index] = note.noteId
        }
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
    
    func deleteNote(index: Int) {
        if managedContextSet {
            if index < 0 || index > currentIndex - 1 {
                return
            }
            
            let noteUUID = noteIndexToId[index]
            NotesCoreData.removeNoteCoreData(deleteNoteId: noteUUID!, fromManageObjectContext: self.managedObjectContext)
            if (index < currentIndex - 1) {
                for i in index...currentIndex - 2 {
                    noteIndexToId[i] = noteIndexToId[i + 1]
                }
            }
            noteIndexToId.removeValue(forKey: currentIndex)
            currentIndex -= 1
        }
    }
    
    func count() -> Int {
        return NotesCoreData.count
    }
}

