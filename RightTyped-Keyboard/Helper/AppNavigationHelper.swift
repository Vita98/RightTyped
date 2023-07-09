//
//  NavigationHelper.swift
//  RightTyped-Keyboard
//
//  Created by Vitandrea Sorino on 09/07/23.
//

import Foundation
import UIKit

class AppNavigationHelper{
    
    private init(){}
    static let shared: AppNavigationHelper = AppNavigationHelper()
    private let APP_PATH = "RightTyped://com.vitAndreAS.RightTyped"
    
    @objc private func openURL(_ url: URL) {
       return
    }

    public func openApp(_ resp: UIResponder?) {
        var responder = resp
        let selector = #selector(openURL(_:))
        while responder != nil {
            if responder!.responds(to: selector) && responder != resp {
                responder!.perform(selector, with: URL(string: APP_PATH)!)
                return
            }
            responder = responder?.next
        }
    }
}
