//
//  CoreDataManager.swift
//  Notes&Events
//
//  Created by Nikolay Budai on 28.10.22.
//

import Foundation
import CoreData

final class CoreDataManager {
    
    static let shared = CoreDataManager(modelName: "Notes_Events")

    let persistentContainer: NSPersistentContainer
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    init(modelName: String) {
        persistentContainer = NSPersistentContainer(name: modelName)
    }

    func load(completion: (() -> Void)? = nil) {
        persistentContainer.loadPersistentStores { description, error in
            guard error == nil else {
                fatalError(error!.localizedDescription)
            }
            
            completion?()
        }
    }

    func saveContext() {
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                print("Error while saving: \(error.localizedDescription)")
            }
        }
    }
    
}


extension CoreDataManager {
    
    func createNote() -> Note {
        let note = Note(context: viewContext)
        note.text = ""
        note.lastUpdated = Date()
        saveContext()
        return note
    }
    
//    func fetchNotes(filter: String? = nil) -> [Note] {
//
//        let request: NSFetchRequest<Note> = Note.fetchRequest()
//        let sortDescriptor = NSSortDescriptor(keyPath: \Note.lastUpdated, ascending: false)
//        request.sortDescriptors = [sortDescriptor]
//
//        if let filter = filter {
//            let predicate = NSPredicate(format: "text contains[cd] %@", filter)
//            request.predicate = predicate
//        }
//
//        return (try? viewContext.fetch(request)) ?? []
//
//    }
    
    func deleteNote(_ note: Note) {
        viewContext.delete(note)
        saveContext()
    }
    
    func createNotesFetchResultsController(filter: String? = nil, isSortedByPriority: Bool) -> NSFetchedResultsController<Note> {
        
        let request: NSFetchRequest<Note> = Note.fetchRequest()
        let sortDescriptor: NSSortDescriptor

        if isSortedByPriority {
            sortDescriptor = NSSortDescriptor(keyPath: \Note.priority, ascending: false)
        } else {
            sortDescriptor = NSSortDescriptor(keyPath: \Note.lastUpdated, ascending: false)
        }
        
        request.sortDescriptors = [sortDescriptor]
        
        if let filter = filter {
            let predicate = NSPredicate(format: "text contains[cd] %@", filter)
            request.predicate = predicate
        }
        
        return NSFetchedResultsController(fetchRequest: request, managedObjectContext: viewContext, sectionNameKeyPath: nil, cacheName: nil)
    }
    
}
