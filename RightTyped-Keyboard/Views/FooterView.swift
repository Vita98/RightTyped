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
    
    var goToAppButton: UIButton = {
        var button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.imageEdgeInsets = .init(top: 8, left: 5, bottom: 8, right: 5)
        button.layer.cornerRadius = 5
        button.imageView?.contentMode = .scaleAspectFit
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
        setUndoButton(enabled: false)
        self.addSubview(hStackView)
        
        hStackView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        hStackView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        self.addSubview(goToAppButton)
        goToAppButton.heightAnchor.constraint(equalToConstant: GLOBE_ICON_SIZE.height).isActive = true
        goToAppButton.widthAnchor.constraint(equalToConstant: GLOBE_ICON_SIZE.width).isActive = true
        goToAppButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10).isActive = true
        goToAppButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
    
    public func textDidChange(appearance: UIKeyboardAppearance){
        if appearance == .light{
            globeButton.setImage(UIImage(named: "globeIcon")?.withTintColor(.black), for: .normal)
            globeButton.backgroundColor = .white
            undoButton.setImage(UIImage(named: "undoIcon")?.withTintColor(.black), for: .normal)
            undoButton.backgroundColor = undoButtonEnabled ? .white : .white.withAlphaComponent(0.9)
            goToAppButton.setImage(UIImage(named: "rIcon")?.withTintColor(.black), for: .normal)
            goToAppButton.backgroundColor = .white
            
        }else{
            globeButton.setImage(UIImage(named: "globeIcon")?.withTintColor(.white), for: .normal)
            globeButton.backgroundColor = .cellDarkBackgroudColor
            undoButton.setImage(UIImage(named: "undoIcon")?.withTintColor(.white), for: .normal)
            undoButton.backgroundColor = .cellDarkBackgroudColor
            goToAppButton.setImage(UIImage(named: "rIcon")?.withTintColor(.white), for: .normal)
            goToAppButton.backgroundColor = .cellDarkBackgroudColor
        }
    }
    
    public func setUndoButton(enabled: Bool){
        undoButtonEnabled = enabled
        
        UIView.transition(with: undoButton, duration: 0.3) {
            self.undoButton.isEnabled = enabled
            
            if enabled && self.undoButton.backgroundColor != .cellDarkBackgroudColor{
                self.undoButton.backgroundColor = self.undoButton.backgroundColor?.withAlphaComponent(1)
            }else if !enabled && self.undoButton.backgroundColor != .cellDarkBackgroudColor{
                self.undoButton.backgroundColor = self.undoButton.backgroundColor?.withAlphaComponent(0.9)
            }
        }
    }
}
