//
//  Answer+CoreDataProperties.swift
//  RightTyped
//
//  Created by Vitandrea Sorino on 08/06/23.
//
//

import Foundation
import CoreData


extension Answer {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Answer> {
        return NSFetchRequest<Answer>(entityName: "Answer")
    }

    @NSManaged public var title: String
    @NSManaged public var descr: String
    @NSManaged public var category: Category?
    @NSManaged public var enabled: Bool
    
    public func copy() -> Answer {
        let copy = Answer(entity: Answer.entity(), insertInto: nil)
        copy.title = self.title
        copy.descr = self.descr
        copy.enabled = self.enabled
        return copy
    }

}

extension Answer : Identifiable {

}
