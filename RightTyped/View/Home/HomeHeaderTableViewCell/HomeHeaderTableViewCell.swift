//
//  HomeHeaderTableViewCell.swift
//  RightTyped
//
//  Created by Vitandrea Sorino on 31/05/23.
//

import UIKit

class HomeHeaderTableViewCell: UITableViewCell {
    
    public static var reuseID = "homeHeaderTableViewCellID"
    private var isFirstTimeOpening = true

    @IBOutlet private weak var categoryCollectionViewFlowLayout: UICollectionViewFlowLayout! {
        didSet {
            categoryCollectionViewFlowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        }
    }
    
    public var selectedCategory: Category? {
        didSet{
            categorySwitch.setOn(selectedCategory!.enabled, animated: isFirstTimeOpening ? false : true)
            isFirstTimeOpening = false
        }
    }
    
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    @IBOutlet private weak var categorySwitch: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        categorySwitch.onTintColor = .componentColor
        categoryCollectionView.register(UINib(nibName: "CategoryCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: CategoryCollectionViewCell.reuseID)
    }

    @IBAction func categorySwitchValueChanged(_ sender: Any) {
        if let selectedCategory = self.selectedCategory{
            selectedCategory.enabled = categorySwitch.isOn
            selectedCategory.save()
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
