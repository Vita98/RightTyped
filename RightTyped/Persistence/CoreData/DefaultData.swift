//
//  DefaultData.swift
//  RightTyped
//
//  Created by Vitandrea Sorino on 11/06/23.
//

import Foundation
import CoreData

private let NAME_KEY = "NAME"
private let ANSWERS_KEY = "ANSWERS"
private let TITLE_KEY = "TITLE"
private let DESC_KEY = "DESC"

private let HARD_CODED_DATA: [[String:Any]] = [[NAME_KEY:"Bella categoria0", ANSWERS_KEY:[[TITLE_KEY:"Titolo della risposta0", DESC_KEY: "Descrizione della risposta0"],
                                                                                           [TITLE_KEY:"Titolo della risposta12", DESC_KEY: "Descrizione della risposta12"]]],
                                                [NAME_KEY:"Bella categoria1", ANSWERS_KEY:[[TITLE_KEY:"Titolo della risposta1", DESC_KEY: "Descrizione della risposta1"]]],
                                                [NAME_KEY:"Bella categoria2", ANSWERS_KEY:[[TITLE_KEY:"Titolo della risposta2", DESC_KEY: "Descrizione della risposta2"]]]]

class DefaultData{
    
    public static var shared: DefaultData = DefaultData()
    
    private init(){}
    
    public func saveDefaultData() {
        for category in HARD_CODED_DATA{
            let catObj = Category(context: DataModelManagerPersistentContainer.shared.context)
            catObj.name = category[NAME_KEY] as! String
            
            let answ_keys = category[ANSWERS_KEY] as! [[String:Any]]
            for answ in answ_keys{
                let answObj = Answer(context: DataModelManagerPersistentContainer.shared.context)
                answObj.title = answ[TITLE_KEY] as! String
                answObj.descr = answ[DESC_KEY] as! String
                catObj.addToAnswers(answObj)
            }
            Category.saveNewCategory(category: catObj)
        }
    }
}
