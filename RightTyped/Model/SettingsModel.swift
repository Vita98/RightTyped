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
            return SettingsType(name: self.rawValue, index: 0)
        case .Keyboard:
            return SettingsType(name: self.rawValue, index: 1)
        case .Tutorial:
            return SettingsType(name: self.rawValue, index: 2)
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
        return [SettingsCellModel(type: .App, itemType: .touchID, text: "Touch ID"),
                SettingsCellModel(type: .Keyboard, itemType: .goBackToDefaultKeyboard, text: "Ritorna sulla tastiera di default all'inserire di una risposta"),
                SettingsCellModel(type: .Tutorial, itemType: .howToEnableKeyboard, text: "Come abilitare la tastiera"),
                SettingsCellModel(type: .Tutorial, itemType: .howToUseKeyboard, text: "Come usare la tastiera"),
                SettingsCellModel(type: .Tutorial, itemType: .howToCustomizeKeyboard, text: "Come personalizzare la tastiera utilizzando l'app"),]
    }()
    
    static func value(at index: IndexPath) -> SettingsCellModel{
        return SettingsModelHelper.values[index.row+index.section]
    }
    
    static func numberOfTutorial(for settingsTypeEnum: SettingsTypeEnum) -> Int{
        return SettingsModelHelper.values.filter({$0.type == settingsTypeEnum}).count
    }
}
