//
//  HomeHeaderTableViewCell.swift
//  RightTyped
//
//  Created by Vitandrea Sorino on 31/05/23.
//

import UIKit

class HomeHeaderTableViewCell: UITableViewCell {
    
    public static var reuseID = "homeHeaderTableViewCellID"

    @IBOutlet weak var categoryCollectionViewFlowLayout: UICollectionViewFlowLayout! {
        didSet {
            categoryCollectionViewFlowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        }
    }
    
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    @IBOutlet weak var categorySwitch: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        categorySwitch.onTintColor = .componentColor
        categoryCollectionView.register(UINib(nibName: "CategoryCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: CategoryCollectionViewCell.reuseID)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
