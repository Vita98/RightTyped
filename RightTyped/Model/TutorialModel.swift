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
    case images
}

struct StackContentItem{
    var content: [String]
    var type: StackContentType
    var size: [CGSize]?
}

// MARK: Tutorial Model
struct TutorialPageModel{
    let gifPath: String
    let gifViewCornerRadius: Double
    var gifHeightMultiplierOnSmallDevices: Double?
    let stackContent: [StackContentItem]
    var final: Bool = false
    
    internal init(gifPath: String, gifViewCornerRadius: Double = 30, gifHeightMultiplierOnSmallDevices: Double? = nil, stackContent: [StackContentItem]) {
        self.gifPath = gifPath
        self.stackContent = stackContent
        self.gifViewCornerRadius = gifViewCornerRadius
        self.gifHeightMultiplierOnSmallDevices = gifHeightMultiplierOnSmallDevices
    }
    
    internal init(stackContent: [StackContentItem], final: Bool){
        self.stackContent = stackContent
        self.gifPath = ""
        self.final = final
        self.gifViewCornerRadius = 0
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
    private init(){}
    static let HOW_TO_USE_KEYBOARD: TutorialModel =
    TutorialModel(title: AppString.Tutorials.HOW_TO_USE_KEYBOARD.title, pageModels: [
        TutorialPageModel(gifPath: "tut2-1", stackContent: [
            StackContentItem(content: [AppString.Tutorials.HOW_TO_USE_KEYBOARD.openKeyboard], type: .text),
            StackContentItem(content: ["globeIcon"], type: .image, size: [CGSize(width: 35, height: 35)]),
            StackContentItem(content: [AppString.Tutorials.HOW_TO_USE_KEYBOARD.selectKeyboard], type: .text)]),
        TutorialPageModel(gifPath: "tut2-5", stackContent: [
            StackContentItem(content: [AppString.Tutorials.HOW_TO_USE_KEYBOARD.keyboardPopUp], type: .text)]),
        TutorialPageModel(gifPath: "tut2-2", stackContent: [
            StackContentItem(content: [AppString.Tutorials.HOW_TO_USE_KEYBOARD.selectAnswer], type: .text),
            StackContentItem(content: [AppString.Tutorials.HOW_TO_USE_KEYBOARD.clickSend], type: .text)]),
        TutorialPageModel(gifPath: "tut2-3", stackContent: [
            StackContentItem(content: [AppString.Tutorials.HOW_TO_USE_KEYBOARD.mindChanged], type: .text),
            StackContentItem(content: ["undoIcon"], type: .image, size: [CGSize(width: 35, height: 25)]),
            StackContentItem(content: [AppString.Tutorials.HOW_TO_USE_KEYBOARD.clickBack], type: .text)]),
        TutorialPageModel(gifPath: "tut2-4", stackContent: [
            StackContentItem(content: [AppString.Tutorials.HOW_TO_USE_KEYBOARD.personalizeKeyboard], type: .text),
            StackContentItem(content: ["rIcon"], type: .image, size: [CGSize(width: 35, height: 30)]),
            StackContentItem(content: [AppString.Tutorials.HOW_TO_USE_KEYBOARD.clickAppIcon], type: .text)]),
        TutorialPageModel(stackContent: [
            StackContentItem(content: [AppString.Tutorials.HOW_TO_USE_KEYBOARD.finalTitle], type: .text)], final: true)])
    
    //TODO: Change this tutorial with the proper one
    static let HOW_TO_CUSTOMIZE_KEYBOARD: TutorialModel =
    TutorialModel(title: AppString.Tutorials.HOW_TO_CUSTOMIZE_KEYBOARD.title, pageModels: [
        TutorialPageModel(gifPath: "tut3-1", gifViewCornerRadius: 45, stackContent: [
            StackContentItem(content: [AppString.Tutorials.HOW_TO_CUSTOMIZE_KEYBOARD.dragAndDrop], type: .text),
            StackContentItem(content: [AppString.Tutorials.HOW_TO_CUSTOMIZE_KEYBOARD.orderInApp], type: .text),
        ]),
        TutorialPageModel(gifPath: "tut3-2", stackContent: [
            StackContentItem(content: [AppString.Tutorials.HOW_TO_CUSTOMIZE_KEYBOARD.answerDragAndDrop], type: .text),
            StackContentItem(content: [AppString.Tutorials.HOW_TO_CUSTOMIZE_KEYBOARD.orderInApp], type: .text)]),
        TutorialPageModel(gifPath: "tut3-3", gifViewCornerRadius: 40, gifHeightMultiplierOnSmallDevices: 0.45, stackContent: [
            StackContentItem(content: [AppString.Tutorials.HOW_TO_CUSTOMIZE_KEYBOARD.possibleAction], type: .text),
            StackContentItem(content: ["addIcon", "binIcon", "completeEditIcon"], type: .images, size: [CGSize(width: 35, height: 35),CGSize(width: 35, height: 35),CGSize(width: 35, height: 35)])]),
        TutorialPageModel(stackContent: [
            StackContentItem(content: [AppString.Tutorials.HOW_TO_CUSTOMIZE_KEYBOARD.finalTitle], type: .text)], final: true)])
}
