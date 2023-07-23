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
        messageLabel.font = UIFont.customFont(.normal, size: 12)
        messageLabel.sizeToFit()
        
        UIView.animate(withDuration: 0.2) {
            self.backgroundView = messageLabel
        }
    }

    func restoreEmptyMessage() {
        UIView.animate(withDuration: 0.2) {
            self.backgroundView = nil
        }
    }
}

extension UITableView{    
    func setEmptyMessage(_ message: String, height: Double) {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        
        let messageLabel = UILabel()
        messageLabel.text = message
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = .center;
        messageLabel.font = UIFont.customFont(.normal, size: 18)
        messageLabel.sizeToFit()
        
        view.addSubview(messageLabel)
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        messageLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        messageLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        messageLabel.topAnchor.constraint(equalTo: view.bottomAnchor, constant: -height).isActive = true
        
        UIView.animate(withDuration: 0.2) {
            self.backgroundView = view
        }
    }

    func restoreEmptyMessage() {
        UIView.animate(withDuration: 0.2) {
            self.backgroundView = nil
        }
    }
}
