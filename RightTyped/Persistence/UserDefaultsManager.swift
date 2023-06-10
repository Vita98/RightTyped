//
//  UserDefaultsManager.swift
//  RightTyped
//
//  Created by Vitandrea Sorino on 10/06/23.
//

import Foundation

fileprivate let FIRST_BOOT_KEY = "FIRST_BOOT_KEY"

class UserDefaultManager{
    
    public static let shared: UserDefaultManager = UserDefaultManager()
    
    private init(){}
    
    
    public func isFirstBoot() -> Bool{
        if let _ = UserDefaults.standard.object(forKey: FIRST_BOOT_KEY){
            return false
        }else{
            UserDefaults.standard.set(false, forKey: FIRST_BOOT_KEY)
            return true
        }
    }
}
