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

}
