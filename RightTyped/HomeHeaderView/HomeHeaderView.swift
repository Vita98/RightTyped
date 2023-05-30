//
//  HomeHeaderView.swift
//  RightTyped
//
//  Created by Vitandrea Sorino on 29/05/23.
//

import UIKit

class HomeHeaderView: UIView {
    
    @IBOutlet weak var containerView: UIView!
    static let NIB_NAME = "HomeHeaderView"

    @IBOutlet weak var gradientView: UIView!
    @IBOutlet private weak var separator2: UIView!
    @IBOutlet private weak var separator1: UIView!
        
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    public func configureView(){
        print("porcoDIO")
        containerView.backgroundColor = .none
        containerView.layer.cornerRadius = 45
        containerView.layer.maskedCorners = [.layerMaxXMinYCorner,.layerMinXMinYCorner]
        
        separator1.backgroundColor = separator1.backgroundColor?.withAlphaComponent(0.5)
        separator2.backgroundColor = separator2.backgroundColor?.withAlphaComponent(0.5)
        
        setGradientBackground()
    }
    
    private func setGradientBackground(){
        gradientView.layer.cornerRadius = 45
        gradientView.layer.maskedCorners = [.layerMaxXMinYCorner,.layerMinXMinYCorner]
        
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.white.cgColor,UIColor.white.cgColor, UIColor.white.withAlphaComponent(0.95).cgColor]
        gradient.type = .axial
        gradient.locations = [0.0,0.5,1.0]
        
        gradient.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradient.endPoint = CGPoint(x: 0.5, y: 0.5)
        gradient.frame = gradientView.frame
        
        gradientView.layer.mask = gradient
//        gradientView.layer.addSublayer(gradient)
    }

}
