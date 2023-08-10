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
}

// MARK: Tutorial Model
struct TutorialPageModel{
    let gifPath: String
    let stackContent: [StackContentItem]
}

struct TutorialModel{
    let title: String
    let pageModels: [TutorialPageModel]
    
    func getControllers() -> [UIViewController] {
        var controllers: [UIViewController] = []
        for pageModel in pageModels {
            if let c = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "genericTutorialViewControllerID") as? GenericTutorialViewController{
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
            StackContentItem(content: "globeIcon", type: .image),
            StackContentItem(content: AppString.Tutorials.HOW_TO_USE_KEYBOARD.selectKeyboard, type: .text)]),
        TutorialPageModel(gifPath: "tut2-2", stackContent: [
            StackContentItem(content: AppString.Tutorials.HOW_TO_USE_KEYBOARD.selectAnswer, type: .text),
            StackContentItem(content: AppString.Tutorials.HOW_TO_USE_KEYBOARD.clickSend, type: .text)])])
}
