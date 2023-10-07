//
//  Answer+CoreDataClass.swift
//  RightTyped
//
//  Created by Vitandrea Sorino on 08/06/23.
//
//

import Foundation
import CoreData

@objc(Answer)
public class Answer: NSManagedObject{
    
    
    @discardableResult
    static func saveNewAnswer(answer: Answer) -> (Bool, Answer?){
        guard let category = answer.category else { return (false, nil) }
        if Answer.isEmpty(for: category){
            answer.order = 0
        }else{
            if let order = Answer.getGreatestOrder(for: category){
                answer.order = Double(order + 1)
            }else{
                return (false, nil)
            }
        }
        
        //Check if the object is not associated to the current context
        if answer.managedObjectContext == nil || (answer.managedObjectContext != nil && answer.managedObjectContext! != DataModelManagerPersistentContainer.shared.context){
            let objectToSave = Answer(context: DataModelManagerPersistentContainer.shared.context)
            answer.copyTo(objectToSave)
            return (DataModelManagerPersistentContainer.shared.saveContextWithCheck(), objectToSave)
        }
        return (DataModelManagerPersistentContainer.shared.saveContextWithCheck(), answer)
    }
    
    //MARK: method to manage the reordering of the answers
    internal static func isEmpty(for category: Category) -> Bool{
        let request = Answer.fetchRequest()
        request.predicate = NSPredicate(format: "category == %@", category)
        do{
            let count = try DataModelManagerPersistentContainer.shared.context.count(for: request)
            return count == 0
        }catch{
            return true
        }
    }
    
    static func getGreatestOrder(for category: Category) -> Int? {
        let categoryFetch = Answer.fetchRequest()
        let sortBy = NSSortDescriptor(key: #keyPath(Answer.order), ascending: false)
        categoryFetch.predicate = NSPredicate(format: "category == %@", category)
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
    
    static func saveNewAnswer(toCategory category : Category, withTitle title: String, withDescr descr : String){
        let answer = Answer(context: DataModelManagerPersistentContainer.shared.context)
        answer.title = title
        answer.descr = descr
        answer.category = category
        DataModelManagerPersistentContainer.shared.saveContext()
    }
    
    static func getAnswers(for category: Category) -> [Answer]? {
        let categoryFetch = Answer.fetchRequest()
        let sortByOrder = NSSortDescriptor(key: #keyPath(Answer.order), ascending: false)
        categoryFetch.sortDescriptors = [sortByOrder]
        categoryFetch.predicate = NSPredicate(format: "category == %@", category)
        var answers : [Answer]? = nil
        do {
            let managedContext = DataModelManagerPersistentContainer.shared.context
            let results = try managedContext.fetch(categoryFetch)
            answers = results
        } catch _ as NSError {
            return nil
        }
        return answers
    }
    
    static func getFetchedResultController(for category: Category, delegate : NSFetchedResultsControllerDelegate? = nil, enabled:Bool = true) -> NSFetchedResultsController<Answer>{
        // Create Fetch Request
        let fetchRequest: NSFetchRequest<Answer> = Answer.fetchRequest()

        // Configure Fetch Request
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: #keyPath(Answer.order), ascending: false)]
        fetchRequest.predicate = NSPredicate(format: "enabled == %@ && category == %@ && forceDisabled == false", NSNumber(booleanLiteral: enabled), category)

        // Create Fetched Results Controller
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: DataModelManagerPersistentContainer.shared.context, sectionNameKeyPath: nil, cacheName: nil)

        // Configure Fetched Results Controller
        fetchedResultsController.delegate = delegate
        return fetchedResultsController
    }
    
    //MARK: Methods to truncate all answers after pro disabilitation
    @discardableResult
    static func forceDisableAllExceedingAnswers(forMaximum maximum: Int) -> Bool{
        guard let allCategories = Category.getAllCategory() else { return false }
        
        for cat in allCategories{
            guard let answers = cat.answers?.allObjects as? [Answer], answers.count > maximum else { continue }
            let sorted = answers.sorted(by: {$0.order > $1.order})
            for i in stride(from: sorted.count - 1, to: maximum - 1, by: -1){
                sorted[i].forceDisabled = true
            }
        }
        return DataModelManagerPersistentContainer.shared.saveContextWithRollback()
    }
    
    @discardableResult
    static func forceEnableAllAnswers() -> Bool{
        let categoryFetch = Answer.fetchRequest()
        let sortBy = NSSortDescriptor(key: #keyPath(Answer.order), ascending: false)
        categoryFetch.sortDescriptors = [sortBy]
        do {
            let managedContext = DataModelManagerPersistentContainer.shared.context
            let results = try managedContext.fetch(categoryFetch)
           
            for answ in results{
                answ.forceDisabled = false
            }
            
            return DataModelManagerPersistentContainer.shared.saveContextWithRollback()
        } catch _ as NSError {
            return false
        }
    }
    
}
