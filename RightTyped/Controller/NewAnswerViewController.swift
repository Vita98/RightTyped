//
//  NewAnswerViewController.swift
//  RightTyped
//
//  Created by Vitandrea Sorino on 01/06/23.
//

import UIKit

protocol NewAnswerViewControllerDelegate{
    func newAnswerViewController(didChange answer: Answer, at originIndexPath: IndexPath?)
}

class NewAnswerViewController: UIViewController, CustomComponentDelegate {

    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var containerView: UIView!
    
    @IBOutlet private weak var enableSwitch: UISwitch!
    @IBOutlet private weak var textFieldView: UIView!
    @IBOutlet private weak var textView: UITextView!
    @IBOutlet private weak var bottomView: UIView!
    @IBOutlet private weak var textAreaView: UIView!
    @IBOutlet private weak var textAreaLabelPlaceholder: UILabel!
    
    public var delegate: NewAnswerViewControllerDelegate?
    public var originTableViewIndexPath: IndexPath?
    
    private var customTextField: CustomTextField?
    private var customTextArea: CustomTextArea?
    
    private var answer: Answer? {
        didSet{
            customTextArea?.currentText = answer!.descr
            customTextField?.currentText = answer!.title
            if enableSwitch != nil {
                enableSwitch.setOn(answer!.enabled, animated: false)
            }
            originalAnswer = answer?.copy()
        }
    }
    
    private var originalAnswer: Answer?
    
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
        contentInset.bottom = keyboardFrame.size.height + 20
        scrollView.contentInset = contentInset
        
    }
    
    
    // MARK: setting up the interface
    private func setTextArea(){
        textAreaLabelPlaceholder.removeFromSuperview()
        customTextArea = CustomTextField.instanceFromNib(withNibName: "CustomTextArea")
        guard let customTextArea = self.customTextArea else { return }
        customTextArea.inizalize(inView: textAreaView, withText: answer?.descr, placheolder: "Che placeholder")
        customTextArea.delegate = self
    }
    
    private func setTextField(){
        customTextField = CustomTextField.instanceFromNib(withNibName: "CustomTextField")
        guard let customTextField = self.customTextField else { return }
        customTextField.inizalize(inView: textFieldView, withText: answer?.title, placheolder: "questo è")
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
            if let saved = answer?.save(), saved{
                originalAnswer = answer?.copy()
                bottomView.enableComponentButtonMode(enabled: isSavabled(), animated: true)
                delegate?.newAnswerViewController(didChange: answer!, at: originTableViewIndexPath)
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
