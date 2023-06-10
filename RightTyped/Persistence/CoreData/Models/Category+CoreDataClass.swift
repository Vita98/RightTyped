//
//  Category+CoreDataClass.swift
//  RightTyped
//
//  Created by Vitandrea Sorino on 08/06/23.
//
//

import Foundation
import CoreData

@objc(Category)
public class Category: NSManagedObject {
    
    static func saveNewCategory(category: Category){
        category.creationDate = Date()
        DataModelManagerPersistentContainer.shared.saveContext()
    }
    
    static func saveNewCategory(name: String){
        let newCategory = Category(context: DataModelManagerPersistentContainer.shared.context)
        newCategory.name = name
        newCategory.creationDate = Date()
        DataModelManagerPersistentContainer.shared.saveContext()
    }
    
    static func getAllCategory() -> [Category]? {
        let categoryFetch = Category.fetchRequest()
        let sortByName = NSSortDescriptor(key: #keyPath(Category.name), ascending: false)
        categoryFetch.sortDescriptors = [sortByName]
        var category : [Category]? = nil
        do {
            let managedContext = DataModelManagerPersistentContainer.shared.context
            let results = try managedContext.fetch(categoryFetch)
            category = results
        } catch let error as NSError {
            print("Fetch error: \(error) description: \(error.userInfo)")
        }
        return category
    }
    
    static func getFetchedResultController(delegate : NSFetchedResultsControllerDelegate? = nil) -> NSFetchedResultsController<Category>{
        // Create Fetch Request
        let fetchRequest: NSFetchRequest<Category> = Category.fetchRequest()

        // Configure Fetch Request
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: #keyPath(Category.creationDate), ascending: false)]

        // Create Fetched Results Controller
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: DataModelManagerPersistentContainer.shared.context, sectionNameKeyPath: nil, cacheName: nil)

        // Configure Fetched Results Controller
        fetchedResultsController.delegate = delegate
        return fetchedResultsController
    }
}
