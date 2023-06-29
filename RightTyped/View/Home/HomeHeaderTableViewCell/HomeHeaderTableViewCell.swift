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
    private var enabled: Bool = true

    @IBOutlet weak var categoryCollectionView: UICollectionView!
    @IBOutlet private weak var categorySwitch: UISwitch!
    
    @IBOutlet private weak var changeContentView: UIView!
    @IBOutlet private weak var editIconImageView: UIImageView!
    @IBOutlet private weak var editLabel: UILabel!
    
    @IBOutlet private weak var deleteContentView: UIView!
    @IBOutlet private weak var deleteIconImageView: UIImageView!
    @IBOutlet private weak var deleteLabel: UILabel!
    
    @IBOutlet private weak var addImageView: UIImageView!
    
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
            }else if sender.view == changeContentView, self.enabled{
                delegate.homeHeaderTableViewCellDidPressed(event: .Change)
            }else if self.enabled{
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
    
    //MARK: Public configuration
    public func enableComponent(enabled: Bool, animated: Bool = false){
        self.enabled = enabled
        UIView.animate(withDuration: animated ? 0.3 : 0) {[weak self] in
            guard let strongSelf = self else { return }
            strongSelf.categorySwitch.isEnabled = enabled
            if enabled{
                strongSelf.editLabel.textColor = .componentColor
                strongSelf.deleteLabel.textColor = .componentColor
                strongSelf.editIconImageView.image = strongSelf.editIconImageView.image?.withTintColor(.componentColor)
                strongSelf.deleteIconImageView.image = strongSelf.deleteIconImageView.image?.withTintColor(.componentColor)
            }else{
                strongSelf.editLabel.textColor = .componentColor.disabled()
                strongSelf.deleteLabel.textColor = .componentColor.disabled()
                strongSelf.editIconImageView.image = strongSelf.editIconImageView.image?.withTintColor(.componentColor.disabled())
                strongSelf.deleteIconImageView.image = strongSelf.deleteIconImageView.image?.withTintColor(.componentColor.disabled())
            }
        }
    }
    
    public func setSwitch(enabled: Bool){
        categorySwitch.setOn(enabled, animated: true)
    }
    
    //MARK: Models
    enum PressionEvent{
        case AddNew
        case Delete
        case Change
    }
}
