//
//  NewAnswerViewController.swift
//  RightTyped
//
//  Created by Vitandrea Sorino on 01/06/23.
//

import UIKit

class NewAnswerViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var enableSwitch: UISwitch!
    @IBOutlet weak var textFieldView: UIView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var bottomView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpObserver()
        
        setNavigationBarView()
        setView()
        
        scrollView.alwaysBounceVertical = false
        textView.clipsToBounds = true
        enableSwitch.onTintColor = .componentColor
        
        setBottomView()
        setTextField()
    }
    
    private func setUpObserver(){
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
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
    
    private func setTextField(){
        guard let viewCustom : CustomTextField = CustomTextField.instanceFromNib(withNibName: "CustomTextField") else { return }
        viewCustom.inizalize(inView: textFieldView, withText: "Che bel testo", placheolder: "questo è")
    }
    
    private func setBottomView(){
        bottomView.layer.cornerRadius = 5
        bottomView.backgroundColor = .componentColor
    }
    
    private func setView(){
        self.view.backgroundColor = .backgroundColor
        containerView.applyCustomRoundCorner()
        containerView.dropShadow(shadowType: .contentView)
        containerView.backgroundColor = .white
        scrollView.applyCustomRoundCorner()
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
