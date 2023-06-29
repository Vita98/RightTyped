//
//  DataModelManager.swift
//  RightTyped
//
//  Created by Vitandrea Sorino on 08/06/23.
//

import Foundation
import CoreData

final class DataModelManagerPersistentContainer: NSPersistentContainer{
    
    var context : NSManagedObjectContext {
        return self.viewContext
    }
    
    static var shared: DataModelManagerPersistentContainer = {
        let storeURL = URL.storeURL(for: "group.vitAndreAS.RightTypedGroup", databaseName: "DataModel")
        let storeDescription = NSPersistentStoreDescription(url: storeURL)
        let container = DataModelManagerPersistentContainer(name: "DataModel")
        container.persistentStoreDescriptions = [storeDescription]
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Unable to load persistent stores: \(error)")
            }
        }
        return container
    }()
    
    func saveContext(backgroundContext: NSManagedObjectContext? = nil) {
        let context = backgroundContext ?? viewContext
        guard context.hasChanges else { return }
        do {
            try context.save()
        } catch let error as NSError {
            print("Error: \(error), \(error.userInfo)")
        }
    }
    
    func saveContextWithCheck(backgroundContext: NSManagedObjectContext? = nil) -> Bool {
        let context = backgroundContext ?? viewContext
        guard context.hasChanges else { return false }
        do {
            try context.save()
            return true
        } catch _ as NSError {
            return false
        }
    }
}

public extension URL {
    /// Returns a URL for the given app group and database pointing to the sqlite database.
    static func storeURL(for appGroup: String, databaseName: String) -> URL {
        guard let fileContainer = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroup) else {
            fatalError("Shared file container could not be created.")
        }

        return fileContainer.appendingPathComponent("\(databaseName).sqlite")
    }
}
