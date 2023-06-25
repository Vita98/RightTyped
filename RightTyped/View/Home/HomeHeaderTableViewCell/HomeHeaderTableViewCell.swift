//
//  HomeHeaderTableViewCell.swift
//  RightTyped
//
//  Created by Vitandrea Sorino on 31/05/23.
//

import UIKit

protocol HomeHeaderTableViewCellDelegate{
    func homeHeaderTableViewCellDidPressed(event: HomeHeaderTableViewCell.PressionEvent)
}

class HomeHeaderTableViewCell: UITableViewCell {
    
    public static var reuseID = "homeHeaderTableViewCellID"
    private var isFirstTimeOpening = true
    public var delegate: HomeHeaderTableViewCellDelegate?

    @IBOutlet private weak var changeContentView: UIView!
    @IBOutlet private weak var deleteContentView: UIView!
    @IBOutlet weak var addImageView: UIImageView!
    
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
        setGestureRecognizer()
    }
    
    //MARK: Configurations
    private func setGestureRecognizer(){
        changeContentView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(buttonsPressed(sender:))))
        deleteContentView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(buttonsPressed(sender:))))
        addImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(buttonsPressed(sender:))))
    }

    //MARK: events
    @objc func buttonsPressed(sender: UITapGestureRecognizer){
        if let delegate = delegate{
            if sender.view is UIImageView{
                delegate.homeHeaderTableViewCellDidPressed(event: .AddNew)
            }else if sender.view == changeContentView{
                delegate.homeHeaderTableViewCellDidPressed(event: .Change)
            }else{
                delegate.homeHeaderTableViewCellDidPressed(event: .Delete)
            }
        }
    }
    
    @IBAction func categorySwitchValueChanged(_ sender: Any) {
        if let selectedCategory = self.selectedCategory{
            selectedCategory.enabled = categorySwitch.isOn
            selectedCategory.save()
        }
    }
    
    //MARK: Models
    enum PressionEvent{
        case AddNew
        case Delete
        case Change
    }
}
