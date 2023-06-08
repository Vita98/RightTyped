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
        let container = DataModelManagerPersistentContainer(name: "DataModel")
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
}
