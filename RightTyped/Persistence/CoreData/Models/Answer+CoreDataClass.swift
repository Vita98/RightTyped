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
    
}
