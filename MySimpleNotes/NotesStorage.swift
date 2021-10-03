//
//  NotesStorage.swift
//  MySimpleNotes
//
//  Created by Eric Grant on 30.09.2021.
//

import CoreData

class NotesStorage {
    
    // MARK: - Properties
    
    static let storage: NotesStorage = NotesStorage()
    
    private var noteIndexToId: [Int: UUID] = [:]
    private var currentIndex: Int = 0

    private(set) var managedObjectContext: NSManagedObjectContext
    private var managedContextSet: Bool = false
    
    private init() {
        // Инициализируем контекст управляемого объекта (который будет перезаписан контроллером представления)
        managedObjectContext = NSManagedObjectContext(
            concurrencyType: NSManagedObjectContextConcurrencyType.mainQueueConcurrencyType)
    }
    
    // MARK: - API
    
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
            // добавляем UUID заметки в словарь
            noteIndexToId[currentIndex] = noteAdded.noteId
            NotesCoreData.makeNoteCoreData(noteCreated: noteAdded, inManagedObjectContext: self.managedObjectContext)
            // увеличиваем индекс
            currentIndex += 1
        }
    }
    
    func readNote(index: Int) -> NotesModel? {
        // проверяем входной индекс
        if managedContextSet {
            if index < 0 || index > currentIndex - 1 {
                return nil
            }
            // получаем UUID заметки из словаря
            let noteUUID = noteIndexToId[index]
            let noteReadCoreData: NotesModel?
            noteReadCoreData = NotesCoreData.readNoteCoreData(readNoteId: noteUUID!, fromManagedObjectContext: self.managedObjectContext)
            return noteReadCoreData
        }
        return nil
    }
    
    func deleteNote(index: Int) {
        if managedContextSet {
            // проверяем входной индекс
            if index < 0 || index > currentIndex - 1 {
                return
            }
            // получаем UUID заметки из словаря
            let noteUUID = noteIndexToId[index]
            NotesCoreData.removeNoteCoreData(deleteNoteId: noteUUID!, fromManageObjectContext: self.managedObjectContext)
            // обновляем словарь
            // удаляемый нами элемент не был последним: обновить GUID
            if (index < currentIndex - 1) {
                // currentIndex - 1 - это индекс последнего элемента
                // но мы удалим последний элемент, поэтому цикл идет только
                // до индекса элемента перед последним элементом
                // который равен currentIndex - 2
                for i in index...currentIndex - 2 {
                    noteIndexToId[i] = noteIndexToId[i + 1]
                }
            }
            // удаляем последний элемент
            noteIndexToId.removeValue(forKey: currentIndex)
            // уменьшаем текущий индекс 
            currentIndex -= 1
        }
    }
    
    func editNote(noteEdited: NotesModel) {
        if managedContextSet {
            // проверяем, есть ли UUID в словаре
            var noteEditedIndex: Int?
            noteIndexToId.forEach { (index: Int, noteId: UUID) in
                if noteId == noteEdited.noteId {
                    noteEditedIndex = index
                    return
                }
            }
            if noteEditedIndex != nil {
                NotesCoreData.editNoteCoreData(noteEdited: noteEdited, inManagedObjectContext: self.managedObjectContext)
            } else {
                
            }
        }
    }
    
    func count() -> Int {
        return NotesCoreData.count
    }
}

