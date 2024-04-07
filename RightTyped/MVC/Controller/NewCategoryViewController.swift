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
    
    //MARK: Outlet
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var closeButton: UIButton!
    @IBOutlet private weak var bottomView: UIView!
    @IBOutlet weak var enableSwitch: UISwitch!
    
    private var customTextField: CustomTextField?
    @IBOutlet private weak var textViewField: UIView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var enableLabel: UILabel!
    @IBOutlet weak var buttonLabel: UILabel!
    @IBOutlet weak var newAnswersImportedLabel: UILabel!
    
    //Import section
    @IBOutlet weak var importContainer: UIView!
    @IBOutlet weak var orLabel: UILabel!
    @IBOutlet weak var importButtonContainer: UIView!
    @IBOutlet weak var importLabel: UILabel!
    @IBOutlet weak var importIcon: UIImageView!
    
    
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
    private var modelFromScan: CategoryShareModel?
    
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
        setTextAndFonts()
        setImportSection()
        
        if !editMode{
            associatedCategory = Category(entity: Category.entity(), insertInto: nil)
            titleLabel.text = AppString.NewCategoryViewController.newCategory
        }else{
            titleLabel.text = AppString.NewCategoryViewController.editCategory
        }
        hideKeyboardWhenTappedAround()
    }
    
    private func setImportSection() {
        if editMode {
            importContainer.isHidden = true
            importContainer.isUserInteractionEnabled = false
            importContainer.heightAnchor.constraint(equalToConstant: 20).isActive = true
        } else {
            importLabel.set(text: AppString.Share.importText, size: 14)
            importIcon.image = UIImage(named: "importIcon")?.withTintColor(.white)
            importButtonContainer.enableComponentButtonMode()
            orLabel.set(text: AppString.Share.or, size: 16)
            importButtonContainer.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(importButtonPressed)))
        }
    }
    
    private func setTextAndFonts(){
        titleLabel.set(size: 24)
        nameLabel.set(text: AppString.NewCategoryViewController.categoryNameTitle, size: 20)
        descriptionLabel.set(text: AppString.NewCategoryViewController.categoryNameDescription, size: 14)
        enableLabel.set(text: AppString.General.enable, size: 20)
        buttonLabel.set(text: AppString.General.save, size: 24)
        newAnswersImportedLabel.set(text: "", size: 14)
    }
    
    private func configureTextField(){
        customTextField = CustomTextField.instanceFromNib(withNibName: "CustomTextField")
        guard let customTextField = self.customTextField else { return }
        customTextField.delegate = self
        customTextField.notDismissableAtIconPression = true
        customTextField.animateBorders = false
        customTextField.startEditingTouchingEverywhere = true
        customTextField.inizalize(inView: textViewField,withText: associatedCategory?.name, placheolder: AppString.NewCategoryViewController.categoryNamePlaceholder)
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
            } else if let _ = modelFromScan {
                return true
            } else if orC.name != currCat.name {
                return true
            }
        }
        return false
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
            if editMode {
                if let saved = associatedCategory?.save(), saved{
                    originalCategory = associatedCategory?.copy()
                    bottomView.enableComponentButtonMode(enabled: isSavabled(), animated: true)
                    delegate?.newCategoryViewController(didChange: associatedCategory!, at: originIndexPath)
                }
            } else {
                if let cat = associatedCategory{
                    var savResp: (Bool, Category?) = (false, nil)
                    if let sharedAnsw = modelFromScan?.answers {
                        savResp = Category.saveNewCategory(category: cat, with: sharedAnsw.map({$0.toManagedObject()}))
                    } else { savResp = Category.saveNewCategory(category: cat) }
                    
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
    
    @objc private func importButtonPressed() {
        let VC = ScannerViewController<CategoryShareModel>()
        VC.modalTransitionStyle = .crossDissolve
        VC.modalPresentationStyle = .overFullScreen
        self.view.endEditing(true)
        self.present(VC, animated: true)
        VC.delegate = self
    }
    
    //MARK: Public configurator
    public func setCategory(_ category: Category?, indexPath: IndexPath? = nil){
        associatedCategory = category
        originIndexPath = indexPath
    }
}

//MARK: ScannerViewControllerDelegate
extension NewCategoryViewController: ScannerViewControllerDelegate {
    func scannerViewControllerDidFound<T: QRCodable>(model: T) {
        guard let newCategory = model as? CategoryShareModel, let answCount = newCategory.answers?.count else {
            //Show generic error
            let alert = UIAlertController(title: AppString.Alerts.genericError, message: AppString.Share.errorWhileImporting, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: AppString.General.close, style: .cancel))
            self.present(alert, animated: true)
            return
        }
        
        //Check category number
        guard Category.canAddCategory() else {
            //Show category error
            let alert = UIAlertController(title: AppString.Alerts.noMoreCategoriesAvailable, message: AppString.Alerts.noMoreCategoriesAvailableDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: AppString.General.close, style: .cancel))
            self.present(alert, animated: true)
            return
        }
        
        //Check answer number
        guard newCategory.checkAnswers() else {
            //Show answers error
            let alert = UIAlertController(title: AppString.General.warning, message: String(format: AppString.Share.errorTooMutchAnswersDescr, String(MAXIMUM_ANSWERS_FOR_CATEGORIES)), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: AppString.General.close, style: .cancel))
            self.present(alert, animated: true)
            return
        }
        
        //Can actually add the category
        self.modelFromScan = newCategory
        self.customTextField?.currentText = newCategory.name
        let resultString : String = String(format: AppString.Plurals.associatedAnswers, answCount)
        
        UIView.transition(with: newAnswersImportedLabel, duration: 0.3) {
            self.newAnswersImportedLabel.text = resultString
            self.newAnswersImportedLabel.layoutIfNeeded()
            self.view.layoutIfNeeded()
        } completion: { _ in
            if let cat = self.associatedCategory {
                cat.name = newCategory.name
            }
            self.bottomView.enableComponentButtonMode(enabled: self.isSavabled(), animated: true)
        }
    }
}
