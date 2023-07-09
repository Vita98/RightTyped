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
    
    var withGlobe: Bool = true
    private var undoButtonEnabled = false
    
    var globeButton: UIButton = {
        var button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.imageEdgeInsets = .init(top: 5, left: 5, bottom: 5, right: 5)
        button.layer.cornerRadius = 5
        button.dropShadow(shadowType: .collectionViewCell)
        button.isEnabled = true
        return button
    }()
    
    var undoButton: UIButton = {
        var button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.imageEdgeInsets = .init(top: 5, left: 5, bottom: 5, right: 5)
        button.layer.cornerRadius = 5
        button.dropShadow(shadowType: .collectionViewCell)
        return button
    }()
    
    var hStackView: UIStackView = {
        var hStackView = UIStackView()
        hStackView.backgroundColor = .clear
        hStackView.axis = .horizontal
        hStackView.alignment = .center
        hStackView.distribution = .fill
        hStackView.spacing = 20
        hStackView.translatesAutoresizingMaskIntoConstraints = false
        return hStackView
    }()
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        if withGlobe{
            globeButton.heightAnchor.constraint(equalToConstant: GLOBE_ICON_SIZE.height).isActive = true
            globeButton.widthAnchor.constraint(equalToConstant: GLOBE_ICON_SIZE.width).isActive = true
            hStackView.addArrangedSubview(globeButton)
        }
        
        undoButton.heightAnchor.constraint(equalToConstant: GLOBE_ICON_SIZE.height).isActive = true
        undoButton.widthAnchor.constraint(equalToConstant: GLOBE_ICON_SIZE.width).isActive = true
        hStackView.addArrangedSubview(undoButton)
        self.addSubview(hStackView)
        
        hStackView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        hStackView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        setUndoButton(enabled: false)
    }
    
    public func textDidChange(appearance: UIKeyboardAppearance){
        if appearance == .light{
            globeButton.setImage(UIImage(named: "globeIcon")?.withTintColor(.black), for: .normal)
            globeButton.backgroundColor = .white
            undoButton.setImage(UIImage(named: "undoIcon")?.withTintColor(.black), for: .normal)
            undoButton.backgroundColor = undoButtonEnabled ? .white : .white.withAlphaComponent(0.9)
        }else{
            globeButton.setImage(UIImage(named: "globeIcon")?.withTintColor(.white), for: .normal)
            globeButton.backgroundColor = .cellDarkBackgroudColor
            undoButton.setImage(UIImage(named: "undoIcon")?.withTintColor(.white), for: .normal)
            undoButton.backgroundColor = undoButtonEnabled ? .cellDarkBackgroudColor : .cellDarkBackgroudColor.withAlphaComponent(0.9)
        }
    }
    
    public func setUndoButton(enabled: Bool){
        undoButtonEnabled = enabled
        
        UIView.transition(with: undoButton, duration: 0.3) {
            self.undoButton.isEnabled = enabled
            self.undoButton.backgroundColor = enabled ? self.undoButton.backgroundColor?.withAlphaComponent(1) : self.undoButton.backgroundColor?.withAlphaComponent(0.9)
        }
    }
}
