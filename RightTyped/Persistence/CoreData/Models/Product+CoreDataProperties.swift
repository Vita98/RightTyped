//
//  Product+CoreDataProperties.swift
//  RightTyped
//
//  Created by Vitandrea Sorino on 16/09/23.
//
//

import Foundation
import CoreData


extension Product {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Product> {
        return NSFetchRequest<Product>(entityName: "Product")
    }

    @NSManaged public var productId: String?
    @NSManaged public var maxCatNum: Int64
    @NSManaged public var maxAnsNum: Int64

}

extension Product : Identifiable {

}
