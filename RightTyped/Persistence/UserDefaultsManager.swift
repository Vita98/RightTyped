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
    
    private let SHARED_GROUP_NAME = "group.vitAndreAS.RightTypedGroup"
    
    
    public static let shared: UserDefaultManager = UserDefaultManager()
    private init(){}
    
    //MARK: Access method
    public func setBoolValue(key: String, enabled: Bool){
        UserDefaults(suiteName: SHARED_GROUP_NAME)?.set(enabled, forKey: key)
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
}
