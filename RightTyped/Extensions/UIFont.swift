//
//  UIFont.swift
//  RightTyped
//
//  Created by Vitandrea Sorino on 23/07/23.
//

import Foundation
import UIKit

enum CustomFontType{
    case normal
    case alt
}

extension UIFont{
    static func customFont(_ type: CustomFontType, size: CGFloat) -> UIFont?{
        switch type {
        case .normal:
            return UIFont(name: CUSTOM_FONT_LIGHT_NAME, size: size)
        case .alt:
            return UIFont(name: CUSTOM_FONT_ALT_LIGHT_NAME, size: size)
        }
    }
}
