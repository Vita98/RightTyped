//
//  NewCategoryViewController.swift
//  RightTyped
//
//  Created by Vitandrea Sorino on 29/06/23.
//

import UIKit

protocol NewCategoryViewControllerDelegate{
    func newCategoryViewController(didChange category: Category, at originIndexPath: IndexPath?)
    func newCategoryViewController(didInsert category: Category)
}

class NewCategoryViewController: UIViewController, CustomComponentDelegate {

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var closeButton: UIButton!
    @IBOutlet private weak var bottomView: UIView!
    @IBOutlet weak var enableSwitch: UISwitch!
    
    private var customTextField: CustomTextField?
    @IBOutlet private weak var textViewField: UIView!
    
    public var editMode = false
    private var associatedCategory: Category? {
        didSet{
            guard let associatedCategory = associatedCategory, !editMode else { return }
            if enableSwitch != nil {
                enableSwitch.setOn(associatedCategory.enabled, animated: false)
            }
            customTextField?.currentText = associatedCategory.name
            originalCategory = associatedCategory.copy()
        }
    }
    private var originalCategory: Category?
    public var originIndexPath: IndexPath?
    public var delegate: NewCategoryViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        if isSavabled(), let associatedCategory = associatedCategory, let originalCategory = originalCategory{
            associatedCategory.name = originalCategory.name
            associatedCategory.enabled = originalCategory.enabled
        }
    }
    
    //MARK: Configuration
    private func configure(){
        closeButton.setTitle("", for: .normal)
        self.contentView.layer.cornerRadius = MODAL_VIEW_ROUND_CORNER
        setBottomView()
        
        enableSwitch.setCustomSwitch()
        if let enableSwitch = enableSwitch, let cat = associatedCategory {
            enableSwitch.setOn(cat.enabled, animated: false)
        }
        
        configureTextField()
        
        if !editMode{
            associatedCategory = Category(entity: Category.entity(), insertInto: nil)
            titleLabel.text = AppString.NewCategoryViewController.newCategory
        }else{
            titleLabel.text = AppString.NewCategoryViewController.editCategory
        }
    }
    
    private func configureTextField(){
        customTextField = CustomTextField.instanceFromNib(withNibName: "CustomTextField")
        guard let customTextField = self.customTextField else { return }
        customTextField.inizalize(inView: textViewField,withText: associatedCategory?.name, placheolder: AppString.NewCategoryViewController.categoryNamePlaceholder)
        customTextField.delegate = self
    }
    
    private func setBottomView(){
        bottomView.enableComponentButtonMode(enabled: false)
        bottomView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(bottomViewTouchUpInside)))
    }
    
    private func isSavabled() -> Bool{
        if let orC = originalCategory, let currCat = associatedCategory{
            if editMode{
                if orC.enabled == currCat.enabled && orC.name == currCat.name{
                    return false
                }else{
                    return true
                }
            }else if orC.name == currCat.name{
                return false
            }else{
                return true
            }
        }else{
            return false
        }
    }
    
    //MARK: CustomTextField delegate
    internal func didSetNewValue(component: UIView, newValue: String) {
        if let cat = associatedCategory{
            cat.name = newValue
        }
        bottomView.enableComponentButtonMode(enabled: isSavabled(), animated: true)
    }

    //MARK: Events
    @IBAction func closeButtonAction(_ sender: Any) {
        if !isSavabled(){
            self.dismiss(animated: true)
        }else{
            let alert = UIAlertController(title: AppString.Alerts.titleAreYouSure, message: AppString.Alerts.genericGoBackWithoutSaving, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: AppString.Alerts.no, style: .cancel))
            alert.addAction(UIAlertAction(title: AppString.Alerts.yes, style: .destructive, handler: { alertAction in
                self.dismiss(animated: true)
            }))
            
            self.present(alert, animated: true)
        }
    }
    
    @IBAction func enableSwitchValueChanged(_ sender: Any) {
        if let associatedCategory = associatedCategory{
            associatedCategory.enabled = enableSwitch.isOn
        }
        bottomView.enableComponentButtonMode(enabled: isSavabled(), animated: true)
    }
    
    @objc func bottomViewTouchUpInside(){
        if isSavabled(){
            if editMode{
                if let saved = associatedCategory?.save(), saved{
                    originalCategory = associatedCategory?.copy()
                    bottomView.enableComponentButtonMode(enabled: isSavabled(), animated: true)
                    //TODO: Call the delegate didChange
                    delegate?.newCategoryViewController(didChange: associatedCategory!, at: originIndexPath)
                }
            }else{
                if let cat = associatedCategory{
                    let savResp = Category.saveNewCategory(category: cat)
                    if savResp.0 {
                        associatedCategory = savResp.1
                        originalCategory = associatedCategory?.copy()
                        bottomView.enableComponentButtonMode(enabled: isSavabled(), animated: true)
                        
                        self.dismiss(animated: true) {[weak self] in
                            if let cat = savResp.1 {
                                self?.delegate?.newCategoryViewController(didInsert: cat)
                            }
                        }
                    }
                }
            }
        }
    }
    
    //MARK: Public configurator
    public func setCategory(_ category: Category?, indexPath: IndexPath? = nil){
        associatedCategory = category
        originIndexPath = indexPath
    }
}
