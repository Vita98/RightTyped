//
//  UIViewController.swift
//  RightTyped
//
//  Created by Vitandrea Sorino on 01/06/23.
//

import Foundation
import UIKit


extension UIViewController{
    
    public func setNavigationBarView(){
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 150, height: 40))
        imageView.contentMode = .scaleAspectFit
        let image = UIImage(named: "appLogo")
        imageView.image = image
        navigationItem.titleView = imageView
    }
    
    /// Method to change the action to execute when the navigationBar back button is pressed.
    /// Must be called in the viewDidAppear because the navigationBar must be already present in the view hierarchy
    /// - Parameter action: the new action to execute
    public func overrideBackAction(action: Selector?){
        self.navigationController?.navigationBar.subviews[1].subviews[1].addGestureRecognizer(UITapGestureRecognizer(target: self, action: action))
    }
}
