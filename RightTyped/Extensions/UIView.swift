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
    case tutorialGifShadow
    
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
            case .tutorialGifShadow:
                return TUTORIAL_GIF_SHADOW
            }
        }
    }
}



extension UIView{
    
    
    /// Method that set the constraint in a way to fill the superview component
    /// - Parameter view: the superview in which the self component must be filled
    public func setFloodConstrait(in view: UIView, leading: Double = 0, trailing: Double = 0){
        self.translatesAutoresizingMaskIntoConstraints = false
        self.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leading).isActive = true
        self.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: trailing).isActive = true
        self.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        self.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
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
    
    public func applyCustomRoundCorner(_ radius: CGFloat? = nil){
        var v = CONTAINER_VIEW_ROUND_CORNER
        if let radius = radius { v = radius }
        self.layer.cornerRadius = v
        self.layer.maskedCorners = [.layerMaxXMinYCorner,.layerMinXMinYCorner]
    }
    
    /// Method to instanciate a view from a xib file
    /// - Parameter nibName: the name of the associated xib file
    /// - Returns: the result UIView
    /// - Warning: if nibName is nil, the xib file must have the same name as the given Generic class T. Force casting to the give T to specify the generic
    class func instanceFromNib<T : UIView>(withNibName nibName: String?) -> T? {
        if let nibName = nibName{
            return UINib(nibName: nibName, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as? T
        }else{
            return UINib(nibName: String(describing: T.self), bundle: nil).instantiate(withOwner: nil, options: nil)[0] as? T
        }
    }
}

//MARK: - Custom addGestureRecognizer
extension UIView {
    
    // In order to create computed properties for extensions, we need a key to
    // store and access the stored property
    fileprivate struct AssociatedObjectKeys {
        static var tapGestureRecognizer = "MediaViewerAssociatedObjectKey_mediaViewer"
    }
    
    fileprivate typealias Action = (() -> Void)?
    
    // Set our computed property type to a closure
    fileprivate var tapGestureRecognizerAction: Action? {
        set {
            if let newValue = newValue {
                // Computed properties get stored as associated objects
                objc_setAssociatedObject(self, &AssociatedObjectKeys.tapGestureRecognizer, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
            }
        }
        get {
            let tapGestureRecognizerActionInstance = objc_getAssociatedObject(self, &AssociatedObjectKeys.tapGestureRecognizer) as? Action
            return tapGestureRecognizerActionInstance
        }
    }
    
    // This is the meat of the sauce, here we create the tap gesture recognizer and
    // store the closure the user passed to us in the associated object we declared above
    public func addTapGestureRecognizer(action: (() -> Void)?) {
        self.isUserInteractionEnabled = true
        self.tapGestureRecognizerAction = action
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
        self.addGestureRecognizer(tapGestureRecognizer)
    }
    
    // Every time the user taps on the UIImageView, this function gets called,
    // which triggers the closure we stored
    @objc fileprivate func handleTapGesture(sender: UITapGestureRecognizer) {
        self.tapGestureRecognizerAction??()
    }
    
}


