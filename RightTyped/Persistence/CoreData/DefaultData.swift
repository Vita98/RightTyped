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

private let HARD_CODED_DATA_IT: [[String:Any]] = [[NAME_KEY:"Italia: più usate 🫶", ANSWERS_KEY:[[TITLE_KEY:"Ti amo!", DESC_KEY: "Ti amo!"],
                                                                                              [TITLE_KEY:"Quando torni?", DESC_KEY: "Quando torni?"],
                                                                                              [TITLE_KEY:"Dove sei?", DESC_KEY: "Dove sei?"],
                                                                                              [TITLE_KEY:"Ci vediamo dopo!", DESC_KEY: "Ci vediamo dopo!"]]],
                                                  [NAME_KEY:"Lavoro 📈", ANSWERS_KEY:[[TITLE_KEY:"Ci sentiamo domani", DESC_KEY: "Ciao, ora non posso rispondere ed è tardi, ci sentiamo direttamente domani in prima mattinata"],
                                                                                 [TITLE_KEY:"Ti invio una email", DESC_KEY: "Certo, non appena ho un momento libero te lo invio tramite email"],
                                                                                 [TITLE_KEY:"Saluti", DESC_KEY: "Ciao, buona serata!"],
                                                                                 [TITLE_KEY:"Sono in riunione", DESC_KEY: "Ciao, sono in riunione e non posso rispondere. Non appena mi libero ti richiamo."]]],
                                                [NAME_KEY:"Pick up lines 😜", ANSWERS_KEY:[[TITLE_KEY:"Cadere dal cielo", DESC_KEY: "Ti sei fatta male? No, perché cadere dal cielo dev'essere stata dura."],
                                                                                           [TITLE_KEY:"Amore a prima vista", DESC_KEY: "Credi nell’amore a prima vista o devo farmi un giro e tornare tra un pò?"],
                                                                                           [TITLE_KEY:"Vieni dallo spazio?", DESC_KEY: "Vieni dallo spazio? No, perché la tua bellezza è fuori da questo mondo."],
                                                                                           [TITLE_KEY:"Dimenticanze", DESC_KEY: "Sei così bella che ho dimenticato la frase da rimorchio."]]]]

private let HARD_CODED_DATA_EN: [[String:Any]] = [[NAME_KEY:"Most common 🫶", ANSWERS_KEY:[[TITLE_KEY:"I love you!", DESC_KEY: "I love you!"],
                                                                                              [TITLE_KEY:"When are you coming back?", DESC_KEY: "When are you coming back?"],
                                                                                              [TITLE_KEY:"Where are you?", DESC_KEY: "Where are you?"],
                                                                                              [TITLE_KEY:"See you later!", DESC_KEY: "See you later!"]]],
                                                  [NAME_KEY:"Office 📈", ANSWERS_KEY:[[TITLE_KEY:"We will talk tomorrow", DESC_KEY: "Hi, now I can't answer and it's late, we'll talk directly tomorrow in the early morning"],
                                                                                 [TITLE_KEY:"I'll send you an email", DESC_KEY: "Sure, as soon as I have a free moment, I'll email it to you"],
                                                                                 [TITLE_KEY:"Greetings", DESC_KEY: "By! Have a nice evening!"],
                                                                                 [TITLE_KEY:"I'm in a meeting!", DESC_KEY: "Hi, I'm in a meeting and can't answer. I'll call you back as soon as I'm free."]]],
                                                [NAME_KEY:"Pick up lines 😜", ANSWERS_KEY:[[TITLE_KEY:"Five cents", DESC_KEY: "If I had a nickel for every time I saw someone as cute as you, I’d have five cents."],
                                                                                           [TITLE_KEY:"Are you from Disneyland?", DESC_KEY: "Are you from Disneyland? They say it’s the happiest place on earth, so I figured it would be wherever you are."],
                                                                                           [TITLE_KEY:"Blinded by your beauty", DESC_KEY: "Look, I’ve been blinded by your beauty. My insurance company is going to need your name and number."],
                                                                                           [TITLE_KEY:"Your eyes are like Ikea.", DESC_KEY: "Your eyes are like Ikea. I’m totally lost in them."],
                                                                                           [TITLE_KEY:"Yoda I am", DESC_KEY: "Roses are red. Violets are blue. Yoda I am. Go out with me will you?"],
                                                                                           [TITLE_KEY:"Hide and seek!", DESC_KEY: "You must be terrible at hide and seek. Someone like you is so hard to find!"]]]]

class DefaultData{
    
    public static var shared: DefaultData = DefaultData()
    
    private init(){}
    
    public func saveDefaultData() {
        let DATA: [[String:Any]]?
        switch AppString.Language.localizedLanguage{
        case AppString.Language.InstalledLanguages.IT.rawValue:
            DATA = HARD_CODED_DATA_IT.reversed()
        case AppString.Language.InstalledLanguages.EN.rawValue:
            DATA = HARD_CODED_DATA_EN.reversed()
        default:
            return
        }
        guard let DATA = DATA else { return }
        for category in DATA {
            let catObj = Category(context: DataModelManagerPersistentContainer.shared.context)
            catObj.name = category[NAME_KEY] as! String
            
            let answ_keys = category[ANSWERS_KEY] as! [[String:Any]]
            var order = 0.0
            for answ in answ_keys.reversed(){
                let answObj = Answer(context: DataModelManagerPersistentContainer.shared.context)
                answObj.title = answ[TITLE_KEY] as! String
                answObj.descr = answ[DESC_KEY] as! String
                answObj.order = order
                catObj.addToAnswers(answObj)
                order = order + 1
            }
            Category.saveNewCategory(category: catObj)
        }
    }
}
