//
//  Category+CoreDataProperties.swift
//  RightTyped
//
//  Created by Vitandrea Sorino on 08/06/23.
//
//

import Foundation
import CoreData


extension Category {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Category> {
        return NSFetchRequest<Category>(entityName: "Category")
    }

    @NSManaged public var name: String
    @NSManaged public var answers: NSSet?
    @NSManaged public var creationDate: Date
    @NSManaged public var enabled: Bool
    @NSManaged public var order: Double
    
}

// MARK: Generated accessors for answers
extension Category {

    @objc(addAnswersObject:)
    @NSManaged public func addToAnswers(_ value: Answer)

    @objc(removeAnswersObject:)
    @NSManaged public func removeFromAnswers(_ value: Answer)

    @objc(addAnswers:)
    @NSManaged public func addToAnswers(_ values: NSSet)

    @objc(removeAnswers:)
    @NSManaged public func removeFromAnswers(_ values: NSSet)
    
    public func copy() -> Category {
        let copy = Category(entity: Category.entity(), insertInto: nil)
        copy.name = self.name
        copy.enabled = self.enabled
        return copy
    }
    
    public func copyTo(_ dest: Category){
        dest.name = name
        dest.creationDate = creationDate
        dest.enabled = enabled
        dest.order = order
    }

}

extension Category : Identifiable {

}
