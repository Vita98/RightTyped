//
//  UIViewController.swift
//  RightTyped
//
//  Created by Vitandrea Sorino on 01/06/23.
//

import Foundation
import UIKit


extension UIViewController{
    
    public func resetBackButtonText(){
        navigationItem.backButtonTitle = ""
    }
    
    public func setNavigationBarView(){
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 150, height: 40))
        imageView.contentMode = .scaleAspectFit
        let image = UIImage(named: "appLogo")
        imageView.image = image
        navigationItem.titleView = imageView
    }
    
    public func setRightBarButtonItem(imageName name: String, gestureRecognizer: UITapGestureRecognizer, withSize size: CGSize){
        let menuBtn = UIButton(type: .custom)
        menuBtn.frame = CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height)
        menuBtn.setImage(UIImage(named:name), for: .normal)
        menuBtn.addGestureRecognizer(gestureRecognizer)
        
        let button = UIBarButtonItem(customView: menuBtn)
        button.customView?.heightAnchor.constraint(equalToConstant: size.height).isActive = true
        button.customView?.widthAnchor.constraint(equalToConstant: size.width).isActive = true
        navigationItem.rightBarButtonItem = button
    }
    
    /// Method to change the action to execute when the navigationBar back button is pressed.
    /// Must be called in the viewDidAppear because the navigationBar must be already present in the view hierarchy
    /// - Parameter action: the new action to execute
    public func overrideBackAction(action: Selector?){
        self.navigationController?.navigationBar.subviews[1].subviews[1].addGestureRecognizer(UITapGestureRecognizer(target: self, action: action))
    }
    
    
    /// Method to dismiss the keyboard touching on any place of the controller
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
