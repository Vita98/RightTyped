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
    @NSManaged public var forceDisabled: Bool
    @NSManaged public var order: Double
    
    //MARK: Init
    public convenience init(into category: Category){
        self.init(context: DataModelManagerPersistentContainer.shared.context)
        self.category = category
        
        if Answer.isEmpty(for: category){
            self.order = 0
        }else{
            if let order = Answer.getGreatestOrder(for: category){
                self.order = Double(order + 1)
            }else{
                self.order = 0
            }
        }
    }
    
    
    public func copy() -> Answer {
        let copy = Answer(entity: Answer.entity(), insertInto: nil)
        copy.title = self.title
        copy.descr = self.descr
        copy.enabled = self.enabled
        copy.order = self.order
        return copy
    }
    
    public func copyTo(_ dest: Answer, order: Bool = false){
        dest.title = title
        dest.descr = descr
        dest.category = category
        dest.enabled = enabled
        dest.order = order ? self.order : dest.order
    }

}

extension Answer : Identifiable {

}
