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
    
    
    static func saveNewCategory(name: String){
        let newCategory = Category(context: DataModelManagerPersistentContainer.shared.context)
        newCategory.name = name
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
}
