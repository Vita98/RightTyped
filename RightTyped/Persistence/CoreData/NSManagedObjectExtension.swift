//
//  NSManagedObjectExtension.swift
//  RightTyped
//
//  Created by Vitandrea Sorino on 12/06/23.
//

import Foundation
import CoreData

extension NSManagedObject{
    
    @discardableResult
    public func save() -> Bool{
        guard hasChanges else { return false }
        do{
            try DataModelManagerPersistentContainer.shared.context.save()
            return true
        }catch{
            return false
        }
    }
}
