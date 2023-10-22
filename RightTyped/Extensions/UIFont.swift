//
//  UIFont.swift
//  RightTyped
//
//  Created by Vitandrea Sorino on 23/07/23.
//

import Foundation
import UIKit

public enum CustomFontType{
    case normal
    case alt
}

extension UIFont{
    public static func customFont(_ type: CustomFontType, size: CGFloat) -> UIFont?{
        switch type {
        case .normal:
            return UIFont(name: "Avenir Light", size: size)
        case .alt:
            return UIFont(name: "Avenir Light", size: size)
        }
    }
}
