//
//  UICheckBox.swift
//  RightTyped
//
//  Created by Vitandrea Sorino on 15/07/23.
//

import UIKit

protocol SelectionDelegate{
    func didSelect(component: UIView, withStatus status: Bool)
}

class UICheckBox: UIButton {
    
    var selectionDelegate: SelectionDelegate?
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }
    
    private func configure(){
        self.setTitle("", for: .normal)
        self.setImage(UIImage(named: "checkboxUnchecked"), for: .normal)
        self.setImage(UIImage(named: "checkboxChecked"), for: .selected)
        self.backgroundColor = .none
        self.isSelected = false
        self.addTarget(self, action: #selector(touchUpInsideEvent), for: .touchUpInside)
    }
    
    @objc private func touchUpInsideEvent(){
        self.isSelected = !self.isSelected
        selectionDelegate?.didSelect(component: self, withStatus: self.isSelected)
    }

}
