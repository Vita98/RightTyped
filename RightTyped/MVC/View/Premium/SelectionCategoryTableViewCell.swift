//
//  SelectionCategoryTableViewCell.swift
//  RightTyped
//
//  Created by Vitandrea Sorino on 07/10/23.
//

import UIKit

protocol SelectionCategoryTableViewCellDelegate{
    func SelectionCategoryTableViewCellStatusChanged(selected: Bool, associatedCategory: Category?)
}

class SelectionCategoryTableViewCell: UITableViewCell {
    
    //MARK: - Outlet
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var selectionImageView: UIImageView!
    
    //MARK: - Private variables
    public var associatedCategory: Category?
    public var delegate: SelectionCategoryTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configure()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: false)
        selectionImageView.image = selected ? UIImage(named: "tickIcon") : UIImage(named: "emptyTickIcon")
        delegate?.SelectionCategoryTableViewCellStatusChanged(selected: selected, associatedCategory: associatedCategory)
    }
    
    //MARK: - Configuration
    private func configure(){
        let view = UIView()
        view.backgroundColor = .componentColor.withAlphaComponent(0.20)
        self.selectedBackgroundView = view
        titleLabel.set(size: 16)
        guard let assCat = associatedCategory else { return }
        titleLabel.text = assCat.name
    }
}
