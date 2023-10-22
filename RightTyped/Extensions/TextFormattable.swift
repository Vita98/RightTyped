//
//  TextFormattable.swift
//  RightTyped
//
//  Created by Vitandrea Sorino on 22/10/23.
//

import Foundation
import UIKit


protocol TextFormattable where Self:UIView {
    func set(text: String, font: UIFont)
    func set(text: String, size: CGFloat)
    func set(size: CGFloat)
    func set(font: UIFont?)
}

extension UILabel: TextFormattable{
    func set(font: UIFont?) {
        self.font = font ?? .systemFont(ofSize: 14)
    }
    
    func set(size: CGFloat) {
        self.font = .customFont(.normal, size: size) ?? .systemFont(ofSize: size)
    }
    
    func set(text: String, size: CGFloat = 14) {
        self.text = text
        self.font = .customFont(.normal, size: size) ?? .systemFont(ofSize: size)
    }
    
    func set(text: String, font: UIFont = .customFont(.normal, size: 14) ?? .systemFont(ofSize: 14)) {
        self.text = text
        self.font = font
    }
}

extension UITextView: TextFormattable{
    func set(font: UIFont?) {
        self.font = font ?? .systemFont(ofSize: 14)
    }
    
    func set(size: CGFloat) {
        self.font = .customFont(.normal, size: size) ?? .systemFont(ofSize: size)
    }
    
    func set(text: String, size: CGFloat = 14) {
        self.text = text
        self.font = .customFont(.normal, size: size) ?? .systemFont(ofSize: size)
    }
    
    func set(text: String, font: UIFont = .customFont(.normal, size: 14) ?? .systemFont(ofSize: 14)) {
        self.text = text
        self.font = font
    }
}

extension UITextField: TextFormattable{
    func set(font: UIFont?) {
        self.font = font ?? .systemFont(ofSize: 14)
    }
    
    func set(size: CGFloat) {
        self.font = .customFont(.normal, size: size) ?? .systemFont(ofSize: size)
    }
    
    func set(text: String, size: CGFloat = 14) {
        self.text = text
        self.font = .customFont(.normal, size: size) ?? .systemFont(ofSize: size)
    }
    
    func set(text: String, font: UIFont = .customFont(.normal, size: 14) ?? .systemFont(ofSize: 14)) {
        self.text = text
        self.font = font
    }
}

extension UIButton: TextFormattable{
    func set(font: UIFont?) {
        self.titleLabel?.font = font ?? .systemFont(ofSize: 14)
    }
    
    func set(size: CGFloat) {
        self.titleLabel?.font = .customFont(.normal, size: size) ?? .systemFont(ofSize: size)
    }
    
    func set(text: String, size: CGFloat = 14) {
        self.setTitle(text, for: .normal)
        self.titleLabel?.font = .customFont(.normal, size: size) ?? .systemFont(ofSize: size)
    }
    
    func set(text: String, font: UIFont = .customFont(.normal, size: 14) ?? .systemFont(ofSize: 14)) {
        self.setTitle(text, for: .normal)
        self.titleLabel?.font = font
    }
}
