//
//  TutorialModel.swift
//  RightTyped
//
//  Created by Vitandrea Sorino on 06/08/23.
//

import Foundation
import UIKit

// MARK: Tutorial page item model
enum StackContentType{
    case image
    case text
}

struct StackContentItem{
    var content: String
    var type: StackContentType
    var size: CGSize?
}

// MARK: Tutorial Model
struct TutorialPageModel{
    let gifPath: String
    let stackContent: [StackContentItem]
    var final: Bool = false
    
    internal init(gifPath: String, stackContent: [StackContentItem]) {
        self.gifPath = gifPath
        self.stackContent = stackContent
    }
    
    internal init(stackContent: [StackContentItem], final: Bool){
        self.stackContent = stackContent
        self.gifPath = ""
        self.final = final
    }
}

struct TutorialModel{
    let title: String
    let pageModels: [TutorialPageModel]
    
    func getControllers(fromSettings: Bool = false, finalAction: (() -> Void)?, isFinalTutorial: Bool = false) -> [UIViewController] {
        var controllers: [UIViewController] = []
        for pageModel in pageModels {
            if pageModel.final{
                //Instantiate the final controller
                if let c = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "finalTutorialViewControllerID") as? FinalTutorialViewController{
                    c.model = pageModel
                    c.fromSettings = fromSettings
                    c.customPressionAction = finalAction
                    c.isFinal = isFinalTutorial
                    controllers.append(c)
                }
            }else if let c = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "genericTutorialViewControllerID") as? GenericTutorialViewController{
                c.model = pageModel
                c.tutTitle = self.title
                controllers.append(c)
            }
        }
        return controllers
    }
}

// MARK: List of all tutorials
struct Tutorials{
    static let HOW_TO_USE_KEYBOARD: TutorialModel =
    TutorialModel(title: AppString.Tutorials.HOW_TO_USE_KEYBOARD.title, pageModels: [
        TutorialPageModel(gifPath: "tut2-1", stackContent: [
            StackContentItem(content: AppString.Tutorials.HOW_TO_USE_KEYBOARD.openKeyboard, type: .text),
            StackContentItem(content: "globeIcon", type: .image, size: CGSize(width: 35, height: 35)),
            StackContentItem(content: AppString.Tutorials.HOW_TO_USE_KEYBOARD.selectKeyboard, type: .text)]),
        TutorialPageModel(gifPath: "tut2-2", stackContent: [
            StackContentItem(content: AppString.Tutorials.HOW_TO_USE_KEYBOARD.selectAnswer, type: .text),
            StackContentItem(content: AppString.Tutorials.HOW_TO_USE_KEYBOARD.clickSend, type: .text)]),
        TutorialPageModel(gifPath: "tut2-3", stackContent: [
            StackContentItem(content: AppString.Tutorials.HOW_TO_USE_KEYBOARD.mindChanged, type: .text),
            StackContentItem(content: "undoIcon", type: .image, size: CGSize(width: 35, height: 25)),
            StackContentItem(content: AppString.Tutorials.HOW_TO_USE_KEYBOARD.clickBack, type: .text)]),
        TutorialPageModel(gifPath: "tut2-4", stackContent: [
            StackContentItem(content: AppString.Tutorials.HOW_TO_USE_KEYBOARD.personalizeKeyboard, type: .text),
            StackContentItem(content: "rIcon", type: .image, size: CGSize(width: 35, height: 30)),
            StackContentItem(content: AppString.Tutorials.HOW_TO_USE_KEYBOARD.clickAppIcon, type: .text)]),
        TutorialPageModel(stackContent: [
            StackContentItem(content: AppString.Tutorials.HOW_TO_USE_KEYBOARD.finalTitle, type: .text)], final: true)])
}
