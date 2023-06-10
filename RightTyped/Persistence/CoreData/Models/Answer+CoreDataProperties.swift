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

    @NSManaged public var title: String?
    @NSManaged public var descr: String?
    @NSManaged public var category: Category?

}

extension Answer : Identifiable {

}
