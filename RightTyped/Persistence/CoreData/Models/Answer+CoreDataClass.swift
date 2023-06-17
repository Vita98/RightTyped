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
    
    
    static func saveNewAnswer(toCategory category : Category, withTitle title: String, withDescr descr : String){
        let answer = Answer(context: DataModelManagerPersistentContainer.shared.context)
        answer.title = title
        answer.descr = descr
        answer.category = category
        DataModelManagerPersistentContainer.shared.saveContext()
    }
    
    static func getAnswers(for category: Category) -> [Answer]? {
        let categoryFetch = Answer.fetchRequest()
        let sortByName = NSSortDescriptor(key: #keyPath(Answer.title), ascending: false)
        categoryFetch.sortDescriptors = [sortByName]
        categoryFetch.predicate = NSPredicate(format: "category == %@", category)
        var answers : [Answer]? = nil
        do {
            let managedContext = DataModelManagerPersistentContainer.shared.context
            let results = try managedContext.fetch(categoryFetch)
            answers = results
        } catch let error as NSError {
            print("Fetch error: \(error) description: \(error.userInfo)")
        }
        return answers
    }
    
    static func getFetchedResultController(for category: Category, delegate : NSFetchedResultsControllerDelegate? = nil, enabled:Bool = true) -> NSFetchedResultsController<Answer>{
        // Create Fetch Request
        let fetchRequest: NSFetchRequest<Answer> = Answer.fetchRequest()

        // Configure Fetch Request
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: #keyPath(Answer.title), ascending: false)]
        fetchRequest.predicate = NSPredicate(format: "enabled == %@ && category == %@", NSNumber(booleanLiteral: enabled), category)

        // Create Fetched Results Controller
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: DataModelManagerPersistentContainer.shared.context, sectionNameKeyPath: nil, cacheName: nil)

        // Configure Fetched Results Controller
        fetchedResultsController.delegate = delegate
        return fetchedResultsController
    }
    
}
