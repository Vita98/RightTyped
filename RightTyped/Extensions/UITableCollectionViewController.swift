//
//  UITableCollectionViewController.swift
//  RightTyped
//
//  Created by Vitandrea Sorino on 25/06/23.
//

import Foundation
import UIKit

extension UICollectionView{
    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = .center;
        messageLabel.font = UIFont(name: "Trakya Rounded 300 Light", size: 12)
        messageLabel.sizeToFit()
        
        UIView.animate(withDuration: 0.2) {
            self.backgroundView = messageLabel
        }
    }

    func restore() {
        UIView.animate(withDuration: 0.2) {
            self.backgroundView = nil
        }
    }
}
