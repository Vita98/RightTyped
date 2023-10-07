//
//  CategoryCollectionViewCell.swift
//  RightTyped
//
//  Created by Vitandrea Sorino on 31/05/23.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    
    public static var reuseID = "categoryCollectionViewCellID"
    public var associatedCategory: Category?

    @IBOutlet weak var label: UILabel!
    
    //CellStyle
    var cellModel : CategoryCell?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        configureCell()
    }
    
    private func configureCell(isSelected : Bool = false){
        cellModel = CategoryCell(isSelected: isSelected)
        self.layer.cornerRadius = 15
        self.layer.borderWidth = 1
        
        self.dropShadow(shadowType: .categoryAppCollectionViewCell)
        
        setSelected(isSelected)
    }
    
    public func setSelected(_ selected : Bool, animated: Bool = false){
        cellModel?.isSelected = selected
        
        if animated{
            UIView.animate(withDuration: 0.3) { [weak self] in
                if let strongSelf = self, let model = strongSelf.cellModel{
                    if selected{
                        strongSelf.backgroundColor = model.selectedStyle.backgroundColor
                        strongSelf.layer.borderColor = model.selectedStyle.borderColor.cgColor
                    }else{
                        strongSelf.backgroundColor = model.deselectedStyle.backgroundColor
                        strongSelf.layer.borderColor = model.deselectedStyle.borderColor.cgColor
                    }
                }
            }
            if let model = cellModel{
                if selected{
                    UIView.transition(with: label, duration: 0.3, options: .transitionCrossDissolve) { [weak self] in
                        self?.label.textColor = model.selectedStyle.textColor
                    }
                }else{
                    UIView.transition(with: label, duration: 0.3, options: .transitionCrossDissolve) { [weak self] in
                        self?.label.textColor = model.deselectedStyle.textColor
                    }
                }
            }
        }else{
            if let model = cellModel{
                if selected{
                    self.backgroundColor = model.selectedStyle.backgroundColor
                    self.label.textColor = model.selectedStyle.textColor
                    self.layer.borderColor = model.selectedStyle.borderColor.cgColor
                }else{
                    self.backgroundColor = model.deselectedStyle.backgroundColor
                    self.label.textColor = model.deselectedStyle.textColor
                    self.layer.borderColor = model.deselectedStyle.borderColor.cgColor
                }
            }
        }
        if let associatedCategory = associatedCategory, let model = cellModel{
            if associatedCategory.forceDisabled{
                self.backgroundColor = .lightGray.withAlphaComponent(0)
                self.layer.borderColor = model.selectedStyle.borderColor.withAlphaComponent(0.2).cgColor
                self.label.alpha = 0.2
            }else{
                self.label.alpha = 1
            }
        }
    }

}
