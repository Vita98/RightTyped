//
//  UIColor.swift
//  RightTyped
//
//  Created by Vitandrea Sorino on 26/05/23.
//

import Foundation
import UIKit

extension UIColor{
    
    /// Consctructor that initialize a rgb color ( 0-255 ) into a UIColor
    /// - Parameters:
    ///   - red: red component ( 0 -255 )
    ///   - green: green component ( 0 -255 )
    ///   - blue: blue component ( 0 -255 )
    ///   - alpha: alpha component ( 0 - 1 )
    convenience init(red: Int, green: Int, blue: Int, alpha: CGFloat = 1.0) {
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: alpha)
    }
    
    public func disabled() -> UIColor{
        return self.withAlphaComponent(DISABLED_COMPONENT_ALPHA)
    }
}

/** DEFINITION OF ALL THE CUSTOM COLOR FOR THE APP **/
extension UIColor{
    public static let backgroundColor = UIColor(named: "backgroundColor")
    public static let componentColor = UIColor(red: 238, green: 108, blue: 77)
    public static let lightComponentColor = UIColor(named: "lightComponentColor")
    public static let placeholderColor = UIColor(named: "placeholderColor")
    public static let textColor = UIColor(named: "textColor")
    
    public static let cellDarkBackgroudColor = UIColor.white.withAlphaComponent(0.2)
    public static let cellLightBackgroudColor = UIColor.white
    public static let cellTextLightColor = UIColor.black
    public static let cellTextlDarkColor = UIColor.white
}
