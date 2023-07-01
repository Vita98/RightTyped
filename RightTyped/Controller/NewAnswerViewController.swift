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

class NewAnswerViewController: UIViewController, CustomComponentDelegate {

    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var containerView: UIView!
    
    @IBOutlet private weak var enableSwitch: UISwitch!
    @IBOutlet private weak var textFieldView: UIView!
    @IBOutlet private weak var bottomView: UIView!
    @IBOutlet private weak var textAreaView: UIView!
    @IBOutlet private weak var textAreaLabelPlaceholder: UILabel!
    @IBOutlet weak var binImageView: UIImageView!
    @IBOutlet weak var binLabel: UILabel!
    
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
            originalAnswer = answer.copy()
        }
    }
    
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
        
        if let enableSwitch = enableSwitch, let answer = answer {
            enableSwitch.setOn(answer.enabled, animated: false)
        }
        
        if isNewAnswer{
            binImageView.isHidden = true
            binLabel.isHidden = true
            
            answer = Answer(entity: Answer.entity(), insertInto: nil)
        }else{
            binImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(deleteIconTouchUpInside)))
        }
        
    }
    
    //MARK: Controller lifecycle
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        overrideBackAction(action: #selector(goBack))
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        if isSavabled(), let answer = answer, let originalAnswer = originalAnswer{
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
        customTextArea.inizalize(inView: textAreaView, withText: answer?.descr, placheolder: "Descrizione della risposta")
        customTextArea.delegate = self
    }
    
    private func setTextField(){
        customTextField = CustomTextField.instanceFromNib(withNibName: "CustomTextField")
        guard let customTextField = self.customTextField else { return }
        customTextField.inizalize(inView: textFieldView, withText: answer?.title, placheolder: "Titolo della risposta")
        customTextField.delegate = self
    }
    
    private func setBottomView(){
        bottomView.enableComponentButtonMode(enabled: false)
        bottomView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(bottomViewTouchUpInside)))
    }
    
    private func setView(){
        self.view.backgroundColor = .backgroundColor
        containerView.applyCustomRoundCorner()
        containerView.dropShadow(shadowType: .contentView)
        containerView.backgroundColor = .white
        scrollView.applyCustomRoundCorner()
    }
    
    public func setAnswer(_ answer: Answer){
        self.answer = answer
    }
    
    public func setAnswerCategory(_ category: Category){
        self.answerCategory = category
    }
    
    private func isSavabled() -> Bool{
        if let orA = originalAnswer, let currAns = answer{
            if orA.enabled == currAns.enabled && orA.descr == currAns.descr && orA.title == currAns.title{
                return false
            }else{
                return true
            }
        }else{
            return false
        }
    }
    
    
    // MARK: Events
    @IBAction func enableSwitchValueChanged(_ sender: Any) {
        if let answer = answer{
            answer.enabled = enableSwitch.isOn
        }
        
        bottomView.enableComponentButtonMode(enabled: isSavabled(), animated: true)
    }
    
    @objc func deleteIconTouchUpInside(){
        let alert = UIAlertController(title: "Sei sicuro?", message: "Sei sicuro di voler cancellare questa risposta?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "No", style: .cancel))
        alert.addAction(UIAlertAction(title: "Si", style: .destructive, handler: { alertAction in
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
        if !isSavabled(){
            navigationController?.popViewController(animated: true)
        }else{
            let alert = UIAlertController(title: "Sei sicuro?", message: "Sei sicuro di voler tornare indietro?\nLe modifiche effettuate non verranno salvate", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "No", style: .cancel))
            alert.addAction(UIAlertAction(title: "Si", style: .destructive, handler: { alertAction in
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
        bottomView.enableComponentButtonMode(enabled: isSavabled(), animated: true)
    }
    
    @objc func bottomViewTouchUpInside(){
        if isSavabled(){
            if isNewAnswer{
                if let answer = answer, let category = answerCategory{
                    let objToSave = Answer(context: DataModelManagerPersistentContainer.shared.context)
                    answer.copyTo(objToSave)
                    category.addToAnswers(objToSave)
                    if category.save() {
                        originalAnswer = answer.copy()
                        bottomView.enableComponentButtonMode(enabled: isSavabled(), animated: true)
                        self.navigationController?.popViewController(animated: true, completion: { [weak self] in
                            self?.delegate?.newAnswerViewController(didInsert: answer)
                        })
                    }
                }
            }else{
                if let saved = answer?.save(), saved{
                    originalAnswer = answer?.copy()
                    bottomView.enableComponentButtonMode(enabled: isSavabled(), animated: true)
                    delegate?.newAnswerViewController(didChange: answer!, at: originTableViewIndexPath)
                }
            }
        }
    }

}
