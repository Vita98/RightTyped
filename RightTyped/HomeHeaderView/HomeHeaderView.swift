//
//  HomeHeaderView.swift
//  RightTyped
//
//  Created by Vitandrea Sorino on 29/05/23.
//

import UIKit

class HomeHeaderView: UIView {

    @IBOutlet weak var containerView: UIView!
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override func draw(_ rect: CGRect) {
        self.backgroundColor = .backgroundColor
        containerView.dropShadow(shadowType: .ContentView)
        containerView.clipsToBounds = true
        containerView.layer.cornerRadius = 45
        containerView.layer.maskedCorners = [.layerMaxXMinYCorner,.layerMinXMinYCorner]
    }

}
