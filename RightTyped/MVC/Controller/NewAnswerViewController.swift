//
//  NewAnswerViewController.swift
//  RightTyped
//
//  Created by Vitandrea Sorino on 01/06/23.
//

import UIKit

protocol NewAnswerViewControllerDelegate{
    func newAnswerViewController(didChange answer: Answer, at originIndexPath: IndexPath?)
    func newAnswerViewController(didDelete answer: Answer, at originIndexPath: IndexPath?)
    func newAnswerViewController(didInsert answer: Answer)
}

class NewAnswerViewController: UIViewController, CustomComponentDelegate, SelectionDelegate {

    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var containerView: UIView!
    
    @IBOutlet private weak var enableSwitch: UISwitch!
    @IBOutlet private weak var textFieldView: UIView!
    @IBOutlet private weak var bottomView: UIView!
    @IBOutlet private weak var textAreaView: UIView!
    @IBOutlet private weak var textAreaLabelPlaceholder: UILabel!
    @IBOutlet weak var binImageView: UIImageView!
    @IBOutlet weak var binLabel: UILabel!
    @IBOutlet weak var checkBox: UICheckBox!
    @IBOutlet weak var useTitleAsBothLabel: UILabel!
    
    @IBOutlet weak var contentTitleLabel: UILabel!
    @IBOutlet weak var contentDescrLabel: UILabel!
    
    public var isNewAnswer: Bool = false
    public var delegate: NewAnswerViewControllerDelegate?
    public var originTableViewIndexPath: IndexPath?
    
    private var customTextField: CustomTextField?
    private var customTextArea: CustomTextArea?
    
    private var answer: Answer? {
        didSet{
            guard let answer = answer else { return }
            customTextArea?.currentText = answer.descr
            customTextField?.currentText = answer.title
            if enableSwitch != nil {
                enableSwitch.setOn(answer.enabled, animated: false)
            }
            if checkBox != nil{
                checkBox.isSelected = answer.title == answer.descr && !isNewAnswer
                originalCheckboxStatus = checkBox.isSelected
                setContentVisibility(!checkBox.isSelected)
            }
            originalAnswer = answer.copy()
        }
    }
    
    private var originalCheckboxStatus: Bool?
    private var originalAnswer: Answer?
    private var answerCategory: Category?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpObserver()
        
        setNavigationBarView()
        setView()
        
        scrollView.alwaysBounceVertical = false
        enableSwitch.onTintColor = .componentColor
        
        setBottomView()
        setTextField()
        setTextArea()
        
        if let answer = answer {
            enableSwitch.setOn(answer.enabled, animated: false)
            checkBox.isSelected = answer.title == answer.descr && !isNewAnswer
            setContentVisibility(!checkBox.isSelected)
        }
        
        binLabel.text = AppString.General.delete
        useTitleAsBothLabel.text = AppString.NewAnswerViewController.useTitleAsBothText
        checkBox.selectionDelegate = self
        originalCheckboxStatus = checkBox.isSelected
        
        if isNewAnswer{
            binImageView.isHidden = true
            binLabel.isHidden = true
            checkBox.isSelected = false
            setContentVisibility(!checkBox.isSelected)
            answer = Answer(entity: Answer.entity(), insertInto: nil)
        }else{
            binImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(deleteIconTouchUpInside)))
        }
        hideKeyboardWhenTappedAround()
    }
    
    //MARK: Controller lifecycle
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        overrideBackAction(action: #selector(goBack))
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        if isSavabled(), areChangesMade(), let answer = answer, let originalAnswer = originalAnswer{
            answer.title = originalAnswer.title
            answer.descr = originalAnswer.descr
            answer.enabled = originalAnswer.enabled
        }
    }
    
    // MARK: observers
    private func setUpObserver(){
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    // MARK: keyboard events
    @objc private func keyboardWillHide(_ notification: Notification){
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
            scrollView.contentInset = contentInset
    }
    
    @objc private func keyboardWillShow(_ notification: Notification){
        guard let userInfo = notification.userInfo else { return }
        var keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)

        var contentInset:UIEdgeInsets = self.scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height + 40
        scrollView.contentInset = contentInset
    }
    
    
    // MARK: setting up the interface
    private func setTextArea(){
        textAreaLabelPlaceholder.removeFromSuperview()
        customTextArea = CustomTextField.instanceFromNib(withNibName: "CustomTextArea")
        guard let customTextArea = self.customTextArea else { return }
        customTextArea.delegate = self
        customTextArea.animateBorders = false
        customTextArea.notDismissableAtIconPression = true
        customTextArea.startEditingTouchingEverywhere = true
        customTextArea.inizalize(inView: textAreaView, withText: answer?.descr, placheolder: AppString.NewAnswerViewController.answerContentPlaceholder)
    }
    
    private func setTextField(){
        customTextField = CustomTextField.instanceFromNib(withNibName: "CustomTextField")
        guard let customTextField = self.customTextField else { return }
        customTextField.delegate = self
        customTextField.notDismissableAtIconPression = true
        customTextField.animateBorders = false
        customTextField.startEditingTouchingEverywhere = true
        customTextField.inizalize(inView: textFieldView, withText: answer?.title, placheolder: AppString.NewAnswerViewController.answerTitlePlaceholder)
    }
    
    private func setBottomView(){
        bottomView.enableComponentButtonMode(enabled: false)
        bottomView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(bottomViewTouchUpInside)))
    }
    
    private func setView(){
        self.view.backgroundColor = .backgroundColor
        containerView.applyCustomRoundCorner()
        containerView.dropShadow(shadowType: .contentView)
        scrollView.applyCustomRoundCorner()
    }
    
    public func setAnswer(_ answer: Answer){
        self.answer = answer
    }
    
    public func setAnswerCategory(_ category: Category){
        self.answerCategory = category
    }
    
    private func areChangesMade() -> Bool{
        if let orA = originalAnswer, let currAns = answer{
            if orA.enabled == currAns.enabled && orA.descr == currAns.descr && orA.title == currAns.title && originalCheckboxStatus == checkBox.isSelected {
                return false
            }else{
                return true
            }
        }else{
            return false
        }
    }
    
    private func isSavabled() -> Bool{
        if let currAns = answer{
            if (!checkBox.isSelected && (currAns.descr.isEmpty || currAns.title.isEmpty)) || (checkBox.isSelected && currAns.title.isEmpty) {
                return false
            }else{
                return true
            }
        }else{
            return false
        }
    }
    
    private func setContentVisibility(_ isVisible: Bool, animated: Bool = false){
        if animated{
            if isVisible{
                contentDescrLabel.isHidden = false
                contentTitleLabel.isHidden = false
                textAreaView.isHidden = false
            }
            UIView.animate(withDuration: 0.2) {[weak self] in
                guard let strongSelf = self else { return }
                if isVisible{
                    strongSelf.contentTitleLabel.alpha = 1
                    strongSelf.contentDescrLabel.alpha = 1
                    strongSelf.textAreaView.alpha = 1
                }else{
                    strongSelf.contentTitleLabel.alpha = 0
                    strongSelf.contentDescrLabel.alpha = 0
                    strongSelf.textAreaView.alpha = 0
                }
            } completion: { [weak self] isDone in
                guard let strongSelf = self else { return }
                if !isVisible{
                    strongSelf.contentDescrLabel.isHidden = true
                    strongSelf.contentTitleLabel.isHidden = true
                    strongSelf.textAreaView.isHidden = true
                }
            }
        }else{
            if isVisible{
                contentDescrLabel.isHidden = false
                contentTitleLabel.isHidden = false
                textAreaView.isHidden = false
                contentTitleLabel.alpha = 1
                contentDescrLabel.alpha = 1
                textAreaView.alpha = 1
            }else{
                contentDescrLabel.isHidden = true
                contentTitleLabel.isHidden = true
                textAreaView.isHidden = true
                contentTitleLabel.alpha = 0
                contentDescrLabel.alpha = 0
                textAreaView.alpha = 0
            }
        }
    }
    
    // MARK: CheckBox Delegate
    func didSelect(component: UIView, withStatus status: Bool) {
        setContentVisibility(!status, animated: true)
        bottomView.enableComponentButtonMode(enabled: isSavabled() && areChangesMade(), animated: true)
    }
    
    // MARK: Events
    @IBAction func enableSwitchValueChanged(_ sender: Any) {
        if let answer = answer{
            answer.enabled = enableSwitch.isOn
        }
        
        bottomView.enableComponentButtonMode(enabled: isSavabled() && areChangesMade(), animated: true)
    }
    
    @objc func deleteIconTouchUpInside(){
        let alert = UIAlertController(title: AppString.Alerts.titleAreYouSure, message: AppString.NewAnswerViewController.deleteAnswerAlertDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: AppString.Alerts.no, style: .cancel))
        alert.addAction(UIAlertAction(title: AppString.Alerts.yes, style: .destructive, handler: { alertAction in
            if let answer = self.answer{
                DataModelManagerPersistentContainer.shared.context.delete(answer)
                DataModelManagerPersistentContainer.shared.saveContext()
                self.delegate?.newAnswerViewController(didDelete: answer, at: self.originTableViewIndexPath)
                self.answer = nil
                self.navigationController?.popViewController(animated: true)
            }
        }))
        
        self.present(alert, animated: true)
    }
    
    @objc func goBack() {
        if !areChangesMade(){
            navigationController?.popViewController(animated: true)
        }else{
            let alert = UIAlertController(title: AppString.Alerts.titleAreYouSure, message: AppString.Alerts.genericGoBackWithoutSaving, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: AppString.Alerts.no, style: .cancel))
            alert.addAction(UIAlertAction(title: AppString.Alerts.yes, style: .destructive, handler: { alertAction in
                self.navigationController?.popViewController(animated: true)
            }))
            
            self.present(alert, animated: true)
        }
    }
    
    func didSetNewValue(component: UIView, newValue: String) {
        if component is CustomTextArea, answer != nil, customTextArea != nil{
            answer!.descr = customTextArea!.currentText!
        }else if component is CustomTextField, answer != nil, customTextField != nil{
            answer!.title = customTextField!.currentText!
        }
        bottomView.enableComponentButtonMode(enabled: isSavabled() && areChangesMade(), animated: true)
    }
    
    @objc func bottomViewTouchUpInside(){
        if isSavabled() && areChangesMade(){
            if let answ = answer{
                if checkBox.isSelected{
                    self.answer?.descr = answ.title
                }else if let txtArea = customTextArea {
                    self.answer?.descr = txtArea.currentText ?? ""
                }
            }
            
            if isNewAnswer{
                if let answer = answer, let category = answerCategory{
                    let objToSave = Answer(into: category)
                    answer.copyTo(objToSave)
                    category.addToAnswers(objToSave)
                    if category.save() {
                        originalAnswer = objToSave.copy()
                        originalCheckboxStatus = checkBox.isSelected
                        bottomView.enableComponentButtonMode(enabled: isSavabled() && areChangesMade(), animated: true)
                        self.navigationController?.popViewController(animated: true, completion: { [weak self] in
                            self?.delegate?.newAnswerViewController(didInsert: objToSave)
                        })
                    }
                }
            }else{
                if let saved = answer?.save(), saved{
                    originalAnswer = answer?.copy()
                    originalCheckboxStatus = checkBox.isSelected
                    bottomView.enableComponentButtonMode(enabled: isSavabled() && areChangesMade(), animated: true)
                    delegate?.newAnswerViewController(didChange: answer!, at: originTableViewIndexPath)
                }
            }
        }
    }

}
