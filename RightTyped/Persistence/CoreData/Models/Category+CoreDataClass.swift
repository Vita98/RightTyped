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
    
    static func needToChooseCategories() -> Bool{
        let request = Category.fetchRequest()
        do{
            let count = try DataModelManagerPersistentContainer.shared.context.count(for: request)
            return count > Product.getMaximumCategoriesCount()
        }catch{
            return true
        }
    }
        
    @discardableResult
    static func saveNewCategory(category: Category) -> (Bool, Category?){
        if Category.isEmpty(){
            category.order = 0
        }else{
            if let order = Category.getGreatestOrder(){
                category.order = Double(order + 1)
            }else{
                return (false, nil)
            }
        }
        category.creationDate = Date()
        
        //Check if the object is not associated to the current context
        if category.managedObjectContext == nil || (category.managedObjectContext != nil && category.managedObjectContext! != DataModelManagerPersistentContainer.shared.context){
            let objectToSave = Category(context: DataModelManagerPersistentContainer.shared.context)
            category.copyTo(objectToSave)
            return (DataModelManagerPersistentContainer.shared.saveContextWithCheck(), objectToSave)
        }
        return (DataModelManagerPersistentContainer.shared.saveContextWithCheck(), category)
    }
    
    @discardableResult
    static func saveNewCategory(category: Category, with answers: [Answer]) -> (Bool, Category?){
        if Category.isEmpty(){
            category.order = 0
        }else{
            if let order = Category.getGreatestOrder(){
                category.order = Double(order + 1)
            }else{
                return (false, nil)
            }
        }
        category.creationDate = Date()
        
        //Check if the object is not associated to the current context
        if category.managedObjectContext == nil || (category.managedObjectContext != nil && category.managedObjectContext! != DataModelManagerPersistentContainer.shared.context){
            let objectToSave = Category(context: DataModelManagerPersistentContainer.shared.context)
            category.copyTo(objectToSave)
            addAnswers(answers: answers, to: objectToSave)
            return (DataModelManagerPersistentContainer.shared.saveContextWithCheck(), objectToSave)
        }
        addAnswers(answers: answers, to: category)
        return (DataModelManagerPersistentContainer.shared.saveContextWithCheck(), category)
    }
    
    private static func addAnswers(answers: [Answer], to category: Category) {
        var answOrder: Double = 0
        for answer in answers {
            answer.order = answOrder
            if answer.managedObjectContext == nil || (answer.managedObjectContext != nil && answer.managedObjectContext! != DataModelManagerPersistentContainer.shared.context){
                let objectToSave = Answer(context: DataModelManagerPersistentContainer.shared.context)
                answer.copyTo(objectToSave)
                objectToSave.category = category
            } else {
                answer.category = category
            }
            answOrder += 1
        }
    }
    
    private static func isEmpty() -> Bool{
        let request = Category.fetchRequest()
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
    
    static func getLowestOrder() -> Int? {
        let categoryFetch = Category.fetchRequest()
        let sortBy = NSSortDescriptor(key: #keyPath(Category.order), ascending: true)
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
    
    static func getAllCategory() -> [Category]? {
        let categoryFetch = Category.fetchRequest()
        let sortByOrder = NSSortDescriptor(key: #keyPath(Category.order), ascending: false)
        categoryFetch.sortDescriptors = [sortByOrder]
        var category : [Category]? = nil
        do {
            let managedContext = DataModelManagerPersistentContainer.shared.context
            let results = try managedContext.fetch(categoryFetch)
            category = results
        } catch _ as NSError {
            return nil
        }
        return category
    }
    
    static func getCategory(enabled: Bool = true, withAtLeastOneEnabledAnswer: Bool = false) -> [Category]? {
        let categoryFetch = Category.fetchRequest()
        let sortByName = NSSortDescriptor(key: #keyPath(Category.order), ascending: false)
        categoryFetch.predicate = NSPredicate(format: "enabled == %@ && forceDisabled == false", NSNumber(booleanLiteral: enabled))
        categoryFetch.sortDescriptors = [sortByName]
        
        var categories : [Category]? = nil
        do {
            let managedContext = DataModelManagerPersistentContainer.shared.context
            let results = try managedContext.fetch(categoryFetch)
            categories = results
            
            if withAtLeastOneEnabledAnswer, let categ = categories{
                categories = categ.filter({ cat in
                    if let answers = cat.answers?.allObjects as? [Answer]{
                        return answers.filter({answ in answ.enabled}).count > 0
                    }else { return false }
                })
            }
        } catch _ as NSError {
            return nil
        }
        return categories
    }
    
    static func getCategoryCount(enabled: Bool = true, withAtLeastOneEnabledAnswer: Bool = false) -> Int {
        let categoryFetch = Category.fetchRequest()
        let sortByName = NSSortDescriptor(key: #keyPath(Category.order), ascending: false)
        categoryFetch.predicate = NSPredicate(format: "enabled == %@ && forceDisabled == false", NSNumber(booleanLiteral: enabled))
        categoryFetch.sortDescriptors = [sortByName]

        var categories : [Category]? = nil
        do {
            let managedContext = DataModelManagerPersistentContainer.shared.context
            let results = try managedContext.fetch(categoryFetch)
            categories = results

            if withAtLeastOneEnabledAnswer, let categ = categories{
                categories = categ.filter({ cat in
                    if let answers = cat.answers?.allObjects as? [Answer]{
                        return answers.filter({answ in answ.enabled}).count > 0
                    }else { return false }
                })
            }
        } catch _ as NSError {
            return 0
        }
        
        if let categories = categories{
            return categories.count
        }else{
            return 0
        }
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
            
        } catch _ as NSError {
            return 0
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
    
    static func getFetchedResultControllerForCategory(delegate : NSFetchedResultsControllerDelegate? = nil, enabled:Bool = true, withAtLeastOneEnabledAnswer: Bool = false) -> NSFetchedResultsController<Category>{
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
    
    @discardableResult
    static func forceDisableAll(except avoidCategories: [Category]) -> Bool{
        let allCat = Category.getAllCategory()
        guard let allCat = allCat, allCat.count > 0, let maxOrder = Category.getLowestOrder() else { return false }
        let avoidIds = avoidCategories.map { $0.id }
        
        var order: Double = Double(maxOrder - 1)
        for cat in allCat{
            if avoidIds.contains(cat.id) { continue }
            cat.forceDisabled = true
            cat.order = order
            order -= 1
        }
        return DataModelManagerPersistentContainer.shared.saveContextWithRollback()
    }
    
    @discardableResult
    static func forceEnableAll() -> Bool{
        let allCat = Category.getAllCategory()
        guard let allCat = allCat else { return false }
        for cat in allCat { cat.forceDisabled = false }
        return DataModelManagerPersistentContainer.shared.saveContextWithRollback()
    }
    
    static func canAddCategory() -> Bool {
        if UserDefaultManager.shared.getProPlanStatus() { return true }
        else {
            guard let count = getAllCategory()?.filter({!$0.forceDisabled}).count else { return false }
            return count < Product.getMaximumCategoriesCount()
        }
    }
    
    static func appendAnswers(answers: Answer) {
        
    }
}
