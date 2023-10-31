//
//  SettingsModel.swift
//  RightTyped
//
//  Created by Vitandrea Sorino on 08/07/23.
//

import Foundation

fileprivate var VALUES_MODEL: [SettingsCellModel] = {
    return [SettingsCellModel(type: .App, itemType: .biometric, text: BiometricHelper.biometricType() ?? "", enabled: BiometricHelper.isBiometricPossible(), cellType: .uiswitch),
            SettingsCellModel(type: .App, itemType: .premium, text: AppString.SettingsModel.premiumText),
            SettingsCellModel(type: .App, itemType: .myPurchases, text: AppString.SettingsModel.myPurchasesText),
            SettingsCellModel(type: .Keyboard, itemType: .goBackToDefaultKeyboard, text: AppString.SettingsModel.goBackToDefaultKeyboardText, cellType: .uiswitch),
            SettingsCellModel(type: .Tutorial, itemType: .howToEnableKeyboard, text: AppString.SettingsModel.howToEnableKeyboardText),
            SettingsCellModel(type: .Tutorial, itemType: .howToUseKeyboard, text: AppString.SettingsModel.howToUseKeyboardText),
            SettingsCellModel(type: .Tutorial, itemType: .howToCustomizeKeyboard, text: AppString.SettingsModel.howToCustomizeKeyboardText),
            SettingsCellModel(type: .Support, itemType: .contactSupport, text: AppString.SettingsModel.contactSupportText),
            SettingsCellModel(type: .TermsConditions, itemType: .termsOfUse, text: AppString.SettingsModel.termsOfUse),
            SettingsCellModel(type: .TermsConditions, itemType: .privacyPolicy, text: AppString.SettingsModel.privacyPolicy),]
}()


typealias SettingsAction = (Bool) -> ()


enum SettingsTypeEnum: String, CaseIterable{
    case App = "App"
    case Keyboard = "Tastiera"
    case Tutorial = "Tutorial"
    case Support = "Supporto"
    case TermsConditions = "TermsConditions"
    
    public func getOrderedVector() -> [SettingsTypeEnum]{
        return [.App, .Keyboard, .Tutorial, .Support, .TermsConditions]
    }
    
    public func getType() -> SettingsType {
        switch self {
        case .App:
            return SettingsType(type: .App, name: AppString.SettingsTypeEnum.app)
        case .Keyboard:
            return SettingsType(type: .Keyboard, name: AppString.SettingsTypeEnum.keyboard)
        case .Tutorial:
            return SettingsType(type: .Tutorial, name: AppString.SettingsTypeEnum.tutorial)
        case .Support:
            return SettingsType(type: .Support, name: AppString.SettingsTypeEnum.support)
        case .TermsConditions:
            return SettingsType(type: .TermsConditions, name: AppString.SettingsTypeEnum.termsConditions)
        }
    }
}

struct SettingsType{
    var type: SettingsTypeEnum
    var name: String
}

enum SettingsItem{
    case biometric
    case premium
    case myPurchases
    case goBackToDefaultKeyboard
    case howToEnableKeyboard
    case howToUseKeyboard
    case howToCustomizeKeyboard
    case contactSupport
    case termsOfUse
    case privacyPolicy
}

enum SettingsCellType{
    case uiswitch
    case plain
}

struct SettingsCellModel{
    var type: SettingsTypeEnum
    var itemType: SettingsItem
    var text: String
    var status: Bool?
    var action: SettingsAction?
    var enabled: Bool = true
    var cellType: SettingsCellType = .plain
}

struct SettingsModelHelper{
    public static let shared: SettingsModelHelper = SettingsModelHelper()
    
    private init(){
        //populating the vector
        var typeAlreadyInserted: [SettingsTypeEnum] = []
        
        for value in VALUES_MODEL{
            if value.enabled{
                values.append(value)
                if !typeAlreadyInserted.contains(value.type){
                    settingsType.append(value.type.getType())
                    typeAlreadyInserted.append(value.type)
                }
            }
        }
    }
    
    private var values: [SettingsCellModel] = []
    private var settingsType: [SettingsType] = []
    
    func getNumberOfSection() -> Int{
        var num = 0
        for type in SettingsTypeEnum.allCases{
            if numberOfSettings(for: type) > 0{
                num = num + 1
            }
        }
        return num
    }
    
    func getTypeAtIndex(index: Int) -> SettingsType? {
        if index < settingsType.count{
            return settingsType[index]
        }
        return nil
    }
    
    func value(at index: IndexPath) -> SettingsCellModel{
        var count = 0
        for i in 0..<index.section{
            guard let st = getTypeAtIndex(index: i)?.type else { continue }
            count = count + numberOfSettings(for: st)
        }
        return values[count + index.row]
    }
    
    func numberOfSettings(for settingsTypeEnum: SettingsTypeEnum) -> Int{
        return values.filter({$0.type == settingsTypeEnum && $0.enabled  == true}).count
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
