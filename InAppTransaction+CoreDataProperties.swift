//
//  InAppTransaction+CoreDataProperties.swift
//  RightTyped
//
//  Created by Vitandrea Sorino on 24/09/23.
//
//

import Foundation
import CoreData


extension InAppTransaction {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<InAppTransaction> {
        return NSFetchRequest<InAppTransaction>(entityName: "InAppTransaction")
    }

    @NSManaged public var locale: String
    @NSManaged public var pricePaid: NSNumber?
    @NSManaged public var productId: String
    @NSManaged public var purchaseDate: Date
    @NSManaged public var purchaseDescription: String
    @NSManaged public var transactionId: String

}

extension InAppTransaction : Identifiable {

}
