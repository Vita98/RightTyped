//
//  SettingsModel.swift
//  RightTyped
//
//  Created by Vitandrea Sorino on 08/07/23.
//

import Foundation


typealias SettingsAction = (Bool) -> ()

enum SettingsTypeEnum: String{
    case App = "App"
    case Keyboard = "Tastiera"
    case Tutorial = "Tutorial"
    
    public func getType() -> SettingsType {
        switch self {
        case .App:
            return SettingsType(name: AppString.SettingsTypeEnum.app, index: 0)
        case .Keyboard:
            return SettingsType(name: AppString.SettingsTypeEnum.keyboard, index: 1)
        case .Tutorial:
            return SettingsType(name: AppString.SettingsTypeEnum.tutorial, index: 2)
        }
    }
    
    public static func getTypeAtIndex(index: Int) -> SettingsType? {
        switch index {
        case 0:
            return SettingsTypeEnum.App.getType()
        case 1:
            return SettingsTypeEnum.Keyboard.getType()
        case 2:
            return SettingsTypeEnum.Tutorial.getType()
        default:
            return nil
        }
    }
    
    public static func getTypeEnumAtIndex(index: Int) -> SettingsTypeEnum? {
        switch index {
        case 0:
            return SettingsTypeEnum.App
        case 1:
            return SettingsTypeEnum.Keyboard
        case 2:
            return SettingsTypeEnum.Tutorial
        default:
            return nil
        }
    }
    
    public static var count: Int = {
       return 3
    }()
}

struct SettingsType{
    var name: String
    var index: Int
}

enum SettingsItem{
    case touchID
    case goBackToDefaultKeyboard
    case howToEnableKeyboard
    case howToUseKeyboard
    case howToCustomizeKeyboard
}

struct SettingsCellModel{
    var type: SettingsTypeEnum
    var itemType: SettingsItem
    var text: String
    var status: Bool?
    var action: SettingsAction?
}

struct SettingsModelHelper{
    private init(){}
    
    static var values: [SettingsCellModel] = {
        return [SettingsCellModel(type: .App, itemType: .touchID, text: AppString.SettingsModel.touchIDText),
                SettingsCellModel(type: .Keyboard, itemType: .goBackToDefaultKeyboard, text: AppString.SettingsModel.goBackToDefaultKeyboardText),
                SettingsCellModel(type: .Tutorial, itemType: .howToEnableKeyboard, text: AppString.SettingsModel.howToEnableKeyboardText),
                SettingsCellModel(type: .Tutorial, itemType: .howToUseKeyboard, text: AppString.SettingsModel.howToUseKeyboardText),
                SettingsCellModel(type: .Tutorial, itemType: .howToCustomizeKeyboard, text: AppString.SettingsModel.howToCustomizeKeyboardText),]
    }()
    
    static func value(at index: IndexPath) -> SettingsCellModel{
        return SettingsModelHelper.values[index.row+index.section]
    }
    
    static func numberOfTutorial(for settingsTypeEnum: SettingsTypeEnum) -> Int{
        return SettingsModelHelper.values.filter({$0.type == settingsTypeEnum}).count
    }
    
    static func getTutorial(for settingsItem: SettingsItem) -> TutorialModel?{
        switch settingsItem {
        case .howToUseKeyboard:
            return Tutorials.HOW_TO_USE_KEYBOARD
        case .howToCustomizeKeyboard:
            return Tutorials.HOW_TO_CUSTOMIZE_KEYBOARD
        default:
            return nil
        }
    }
}
