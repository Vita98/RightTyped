//
//  UserDefaultsManager.swift
//  RightTyped
//
//  Created by Vitandrea Sorino on 10/06/23.
//

import Foundation

class UserDefaultManager{
    
    //MARK: Keys
    static let FIRST_BOOT_KEY = "FIRST_BOOT_KEY"
    static let KEYBOARD_EXTENSION_ENABLED_KEY = "AppleKeyboards"
    static let DONT_SHOW_ENABLE_KEYBOARD_AGAIN_KEY = "DONT_SHOW_ENABLE_KEYBOARD_AGAIN_KEY"
    
    //MARK: Settings
    static let BIOMETRIC_ENABLED_KEY = "BIOMETRIC_ENABLED_KEY"
    static let GO_BACK_TO_DEF_KEYBOARD_KEY = "GO_BACK_TO_DEF_KEYBOARD_KEY"
    
    //MARK: Pro plan
    static let PRO_PLAN_ENABLED_KEY = "PRO_PLAN_ENABLED_KEY"
    static let PRO_PLAN_EXPIRATION_DATE_KEY = "PRO_PLAN_EXPIRATION_DATE_KEY"
    static let PRO_PLAN_HAS_JUST_BEEN_DISABLED = "PRO_PLAN_HAS_JUST_BEEN_DISABLED"
    
    private let SHARED_GROUP_NAME = "group.vitAndreAS.RightTypedGroup"
    
    
    public static let shared: UserDefaultManager = UserDefaultManager()
    private init(){}
    
    //MARK: Access method
    public func setBoolValue(key: String, enabled: Bool){
        UserDefaults(suiteName: SHARED_GROUP_NAME)?.set(enabled, forKey: key)
    }
    
    public func setProPlanExpirationDate(_ date: Date?){
        if let date = date {
            UserDefaults(suiteName: SHARED_GROUP_NAME)?.set(date, forKey: UserDefaultManager.PRO_PLAN_EXPIRATION_DATE_KEY)
        }else{
            UserDefaults(suiteName: SHARED_GROUP_NAME)?.removeObject(forKey: UserDefaultManager.PRO_PLAN_EXPIRATION_DATE_KEY)
        }
    }
    
    public func getBoolValue(key: String) -> Bool? {
        return UserDefaults(suiteName: SHARED_GROUP_NAME)?.bool(forKey: key)
    }
    
    public func isKeyboardExtensionEnabled() -> Bool {
        if let keyboards = UserDefaults.standard.object(forKey: UserDefaultManager.KEYBOARD_EXTENSION_ENABLED_KEY) as? [String], keyboards.contains("com.vitAndreAS.RightTyped.RightTyped-Keyboard2023"){
            return true
        }
        return false
    }
    
    public func isFirstBoot() -> Bool{
        if let _ = UserDefaults(suiteName: SHARED_GROUP_NAME)?.object(forKey: UserDefaultManager.FIRST_BOOT_KEY){
            return false
        }else{
            UserDefaults(suiteName: SHARED_GROUP_NAME)?.set(false, forKey: UserDefaultManager.FIRST_BOOT_KEY)
            return true
        }
    }
    
    public func isFirstBootForExtension() -> Bool{
        if let _ = UserDefaults(suiteName: SHARED_GROUP_NAME)?.object(forKey: UserDefaultManager.FIRST_BOOT_KEY){
            return false
        }else{
            return true
        }
    }
    
    public func getProPlanStatus() -> Bool{
        if let status = UserDefaults(suiteName: SHARED_GROUP_NAME)?.bool(forKey: UserDefaultManager.PRO_PLAN_ENABLED_KEY){
            return status
        }else {
            return false
        }
    }
    
    public func hasProPlanJustBeenDisabled() -> Bool{
        if let status = UserDefaults(suiteName: SHARED_GROUP_NAME)?.bool(forKey: UserDefaultManager.PRO_PLAN_HAS_JUST_BEEN_DISABLED){
            return status
        }else {
            return false
        }
    }
    
    public func isProPlanExpired() -> Bool{
        if let expDate = UserDefaults(suiteName: SHARED_GROUP_NAME)?.object(forKey: UserDefaultManager.PRO_PLAN_EXPIRATION_DATE_KEY) as? Date{
            return expDate < Date()
        }else {
            return false
        }
    }
}
