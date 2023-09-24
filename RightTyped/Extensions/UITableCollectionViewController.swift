//
//  UITableCollectionViewController.swift
//  RightTyped
//
//  Created by Vitandrea Sorino on 25/06/23.
//

import Foundation
import UIKit

protocol AdvanceDequeuable{
    func dequeue<T>(for indexPath: IndexPath) -> T?
}

protocol AdvanceRegistrable{
    func register<T>(_ cellType: T.Type)
}

extension UICollectionView: AdvanceDequeuable, AdvanceRegistrable{
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
    
    func dequeue<T>(for indexPath: IndexPath) -> T?{
        return self.dequeueReusableCell(withReuseIdentifier: String(describing: T.self), for: indexPath) as? T
    }
    
    func register<T>(_ cellType: T.Type) {
        self.register(UINib(nibName: String(describing: T.self), bundle: nil), forCellWithReuseIdentifier: String(describing: T.self))
    }
}

extension UITableView: AdvanceDequeuable, AdvanceRegistrable{
    func setEmptyViewForPurchases(withButtonText buttonText: String, topLabelText labelText: String, action: @escaping () -> Void){
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        
        let messageLabel = UILabel()
        messageLabel.text = buttonText
        messageLabel.textColor = .white
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = .center;
        messageLabel.font = UIFont.customFont(.normal, size: 24)
        messageLabel.sizeToFit()
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let topMessageLabel = UILabel()
        topMessageLabel.text = labelText
        topMessageLabel.numberOfLines = 0;
        topMessageLabel.textAlignment = .center;
        topMessageLabel.font = UIFont.customFont(.normal, size: 18)
        topMessageLabel.sizeToFit()
        topMessageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(topMessageLabel)
        topMessageLabel.translatesAutoresizingMaskIntoConstraints = false
        topMessageLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        topMessageLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        topMessageLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        
        let view2 = UIView()
        view2.addSubview(messageLabel)
        view2.heightAnchor.constraint(equalToConstant: 45).isActive = true
        messageLabel.leadingAnchor.constraint(equalTo: view2.leadingAnchor, constant: 20).isActive = true
        messageLabel.trailingAnchor.constraint(equalTo: view2.trailingAnchor, constant: -20).isActive = true
        messageLabel.topAnchor.constraint(equalTo: view2.topAnchor, constant: 0).isActive = true
        messageLabel.bottomAnchor.constraint(equalTo: view2.bottomAnchor, constant: -0).isActive = true
        view2.translatesAutoresizingMaskIntoConstraints = false
        view2.addTapGestureRecognizer(action: action)
        view2.enableComponentButtonMode()
        
        view.addSubview(view2)
        view2.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40).isActive = true
        view2.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40).isActive = true
        view2.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        UIView.animate(withDuration: 0.2) {
            self.backgroundView = view
        }
    }
    
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
    
    func dequeue<T>(for indexPath: IndexPath) -> T?{
        return self.dequeueReusableCell(withIdentifier: String(describing: T.self), for: indexPath) as? T
    }
    
    func register<T>(_ cellType: T.Type) {
        self.register(UINib(nibName: String(describing: T.self), bundle: nil), forCellReuseIdentifier: String(describing: T.self))
    }
}
