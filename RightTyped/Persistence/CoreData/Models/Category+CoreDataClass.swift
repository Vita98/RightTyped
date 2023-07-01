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
        
    @discardableResult
    static func saveNewCategory(category: Category) -> Bool{
        if Category.isEmpty(){
            category.order = 0
        }else{
            if let order = Category.getGreatestOrder(){
                category.order = Double(order + 1)
            }else{
                return false
            }
        }
        category.creationDate = Date()
        
        //Check if the object is not associated to the current context
        if category.managedObjectContext == nil || (category.managedObjectContext != nil && category.managedObjectContext! != DataModelManagerPersistentContainer.shared.context){
            let objectToSave = Category(context: DataModelManagerPersistentContainer.shared.context)
            category.copyTo(objectToSave)
        }
        return DataModelManagerPersistentContainer.shared.saveContextWithCheck()
    }
    
    private static func isEmpty() -> Bool{
        let request = NSFetchRequest<Category>(entityName: "Category")
        do{
            let count = try DataModelManagerPersistentContainer.shared.context.count(for: request)
            return count == 0
        }catch{
            return true
        }
    }
    
    static func getGreatestOrder() -> Int? {
        let categoryFetch = Category.fetchRequest()
        let sortBy = NSSortDescriptor(key: #keyPath(Category.order), ascending: false)
        categoryFetch.sortDescriptors = [sortBy]
        do {
            let managedContext = DataModelManagerPersistentContainer.shared.context
            let results = try managedContext.fetch(categoryFetch)
            if let order = results.first?.order{
                return Int(order)
            }
        } catch _ as NSError {
            return nil
        }
        return nil
    }
    
    static func getAllCategory(enabled: Bool = false) -> [Category]? {
        let categoryFetch = Category.fetchRequest()
        let sortByName = NSSortDescriptor(key: #keyPath(Category.order), ascending: false)
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
    
    static func getCategory(enabled: Bool = true) -> [Category]? {
        let categoryFetch = Category.fetchRequest()
        let sortByName = NSSortDescriptor(key: #keyPath(Category.order), ascending: false)
        categoryFetch.predicate = NSPredicate(format: "enabled == %@", NSNumber(booleanLiteral: enabled))
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
    
    static func getCategoryCount(enabled: Bool = true) -> Int{
        let categoryFetch = Category.fetchRequest()
        let sortByName = NSSortDescriptor(key: #keyPath(Category.order), ascending: false)
        categoryFetch.predicate = NSPredicate(format: "enabled == %@", NSNumber(booleanLiteral: enabled))
        categoryFetch.sortDescriptors = [sortByName]
        
        var count = 0
        do {
            let managedContext = DataModelManagerPersistentContainer.shared.context
            count = try managedContext.count(for: categoryFetch)
            
        } catch let error as NSError {
            print("Fetch error: \(error) description: \(error.userInfo)")
        }
        return count
    }
    
    static func getFetchedResultControllerForAllCategory(delegate : NSFetchedResultsControllerDelegate? = nil) -> NSFetchedResultsController<Category>{
        // Create Fetch Request
        let fetchRequest: NSFetchRequest<Category> = Category.fetchRequest()

        // Configure Fetch Request
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: #keyPath(Category.order), ascending: false)]

        // Create Fetched Results Controller
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: DataModelManagerPersistentContainer.shared.context, sectionNameKeyPath: nil, cacheName: nil)

        // Configure Fetched Results Controller
        fetchedResultsController.delegate = delegate
        return fetchedResultsController
    }
    
    static func getFetchedResultControllerForCategory(delegate : NSFetchedResultsControllerDelegate? = nil, enabled:Bool = true) -> NSFetchedResultsController<Category>{
        // Create Fetch Request
        let fetchRequest: NSFetchRequest<Category> = Category.fetchRequest()

        // Configure Fetch Request
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: #keyPath(Category.order), ascending: false)]
        fetchRequest.predicate = NSPredicate(format: "enabled == %@", NSNumber(booleanLiteral: enabled))

        // Create Fetched Results Controller
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: DataModelManagerPersistentContainer.shared.context, sectionNameKeyPath: nil, cacheName: nil)

        // Configure Fetched Results Controller
        fetchedResultsController.delegate = delegate
        return fetchedResultsController
    }
}
