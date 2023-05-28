//
//  FooterView.swift
//  RightTyped-Keyboard
//
//  Created by Vitandrea Sorino on 28/05/23.
//

import UIKit

class FooterView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    var globeButton = UIButton(type: .custom)
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        globeButton.translatesAutoresizingMaskIntoConstraints = false
        globeButton.imageEdgeInsets = .init(top: 5, left: 5, bottom: 5, right: 5)
        globeButton.layer.cornerRadius = 5
        globeButton.dropShadow(shadowType: .CollectionViewCell)
        globeButton.isEnabled = true
        
        self.addSubview(globeButton)
        
        globeButton.heightAnchor.constraint(equalToConstant: GLOBE_ICON_SIZE.height).isActive = true
        globeButton.widthAnchor.constraint(equalToConstant: GLOBE_ICON_SIZE.width).isActive = true
        globeButton.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        globeButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
    
    public func textDidChange(appearance: UIKeyboardAppearance){
        if appearance == .light{
            globeButton.setImage(UIImage(named: "globeIcon")?.withTintColor(.black), for: .normal)
            globeButton.backgroundColor = .white
        }else{
            globeButton.setImage(UIImage(named: "globeIcon")?.withTintColor(.white), for: .normal)
            globeButton.backgroundColor = .cellDarkBackgroudColor
        }
    }
}
