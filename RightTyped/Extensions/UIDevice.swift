//
//  UIDevice.swift
//  RightTyped
//
//  Created by Vitandrea Sorino on 11/08/23.
//

import Foundation
import UIKit

extension UIDevice{
    public func isSmall() -> Bool{
        return UIScreen.main.bounds.width == 375 && UIScreen.main.bounds.height == 667
    }
}
