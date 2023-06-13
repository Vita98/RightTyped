//
//  UIView.swift
//  RightTyped
//
//  Created by Vitandrea Sorino on 27/05/23.
//

import Foundation
import UIKit


/// Struct used to rapresent a shadows
public struct Shadow{
    var color : CGColor
    var offset : CGSize
    var radius : CGFloat
    var opacity : Float
}


/// Enum used to differenciate variuos shadows type
public enum ShadowType{
    case collectionViewCell
    case contentView
    case categoryAppCollectionViewCell
    
    /// Associatiion between the type and the hardcoded constants
    var value : Shadow {
        get{
            switch self{
            case .collectionViewCell:
                return CATEGORY_CELL_KEYBOARD_SHADOW
            case .contentView:
                return CONTENT_VIEW_SHADOW
            case .categoryAppCollectionViewCell:
                return CATEGORY_CELL_APP_SHADOW
            }
        }
    }
}



extension UIView{
    
    /// Method used to drop a shadow to the view
    /// - Parameter shadowType: type of shadow to drop
    public func dropShadow(shadowType : ShadowType){
        let shadow = shadowType.value
        
        self.layer.shadowColor = shadow.color
        self.layer.shadowOffset = shadow.offset
        self.layer.shadowRadius = shadow.radius
        self.layer.shadowOpacity = shadow.opacity
        self.layer.masksToBounds = false
    }
    
    func animateBorderColor(toColor: UIColor, duration: Double) {
        let animation = CABasicAnimation(keyPath: "borderColor")
        animation.fromValue = layer.borderColor
        animation.toValue = toColor.cgColor
        animation.duration = duration
        layer.add(animation, forKey: "borderColor")
        layer.borderColor = toColor.cgColor
    }
    
    public func enableComponentButtonMode(enabled: Bool = true, animated: Bool = false){
        if animated{
            UIView.animate(withDuration: 0.3) {
                self.backgroundColor = enabled ? .componentColor : .componentColor.withAlphaComponent(0.15)
                self.layer.cornerRadius = 5
            }
        }else{
            self.backgroundColor = enabled ? .componentColor : .componentColor.withAlphaComponent(0.15)
            self.layer.cornerRadius = 5
        }
    }
    
    public func applyCustomRoundCorner(){
        self.layer.cornerRadius = CONTAINER_VIEW_ROUND_CORNER
        self.layer.maskedCorners = [.layerMaxXMinYCorner,.layerMinXMinYCorner]
    }
    
    class func instanceFromNib<T : UIView>(withNibName nibName: String) -> T? {
        return UINib(nibName: nibName, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as? T
    }
}
