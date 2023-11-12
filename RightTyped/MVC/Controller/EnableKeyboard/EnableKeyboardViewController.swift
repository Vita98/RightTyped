//
//  EnableKeyboardViewController.swift
//  RightTyped
//
//  Created by Vitandrea Sorino on 06/06/23.
//

import UIKit

class EnableKeyboardViewController: UIViewController {
    
    @IBOutlet weak var openSettingsView: UIView!
    @IBOutlet weak var keyboardNotEnabledView: UIView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet var closeButtonWidthConstraint: NSLayoutConstraint!
    @IBOutlet var closeButtonTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var closeButtonTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var checkboxButton: UIButton!
    @IBOutlet weak var keyboardNotEnabledLabel: UILabel!
    @IBOutlet weak var doNotShowLabel: UILabel!
    
    @IBOutlet weak var firstStackLabel: UILabel!
    @IBOutlet weak var secondStackLabel: UILabel!
    @IBOutlet weak var orLabel: UILabel!
    @IBOutlet weak var thirdStackLabel: UILabel!
    @IBOutlet weak var goToSettingsLabel: UILabel!
    
    var isCheckboxSelected: Bool = false
    var fromSettings = false
    var showCloseButton = true
    var showSkipButton = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTextsAndFonts()
        
        // Do any additional setup after loading the view.
        self.view.backgroundColor = .backgroundColor
        closeButton.setTitle("", for: .normal)
        checkboxButton.setTitle("", for: .normal)
        openSettingsView.enableComponentButtonMode()
        if UserDefaultManager.shared.isKeyboardExtensionEnabled(){
            keyboardNotEnabledView.enableComponentButtonMode(enabled:false)
            keyboardNotEnabledLabel.text = AppString.EnableKeyboardViewController.keyboardEnabled
        }else{
            keyboardNotEnabledView.enableComponentButtonMode(enabled:false)
            keyboardNotEnabledLabel.text = AppString.EnableKeyboardViewController.keyboardDisabled
        }
        
        if fromSettings{
            doNotShowLabel.isHidden = true
            checkboxButton.isHidden = true
        }
        
        if !showCloseButton {
            if showSkipButton {
                closeButton.isHidden = false
                closeButton.isEnabled = true
                closeButton.removeConstraint(closeButtonWidthConstraint)
                closeButtonTrailingConstraint.constant = 5
                closeButtonTopConstraint.constant = 5
                closeButton.setImage(UIImage(), for: .normal)
                closeButton.setTitle(AppString.General.skip, for: .normal)
                closeButton.setTitleColor(.componentColor, for: .normal)
                closeButton.setTitleColor(.componentColor, for: .highlighted)
            } else {
                closeButton.isHidden = true
                closeButton.isEnabled = false
            }
        }
        
        openSettingsView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openSettings)))
        
        // set observer for UIApplication.willEnterForegroundNotification
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    private func setTextsAndFonts(){
        firstStackLabel.set(text: AppString.EnableKeyboardViewController.firstStackText, size: 24)
        secondStackLabel.set(text: AppString.EnableKeyboardViewController.secondStackText, size: 18)
        thirdStackLabel.set(text: AppString.EnableKeyboardViewController.thirdStackText, size: 18)
        orLabel.set(text: AppString.EnableKeyboardViewController.orText, size: 18)
        keyboardNotEnabledLabel.set(size: 24)
        doNotShowLabel.set(text: AppString.General.doNotShowThisMessage, size: 14)
        goToSettingsLabel.set(text: AppString.EnableKeyboardViewController.goToSettings, size: 24)
    }
    
    deinit{
        NotificationCenter.default.removeObserver(self)
    }
    
    
    @IBAction func closeButtonPression(_ sender: Any) {
        if showSkipButton {
            let viewC: ManagerTutorialViewController = UIStoryboard.main().instantiate()
            viewC.model = Tutorials.HOW_TO_USE_KEYBOARD
            viewC.fromSettings = self.fromSettings
            viewC.showCloseButton = showCloseButton
            viewC.customFinalAction = {[weak self] in
                //Implement the second tutorial
                guard let strongSelf = self else { return }
                let secondTutorial: ManagerTutorialViewController = UIStoryboard.main().instantiate()
                secondTutorial.model = Tutorials.HOW_TO_CUSTOMIZE_KEYBOARD
                secondTutorial.fromSettings = strongSelf.fromSettings
                secondTutorial.isFinalTutorial = true
                secondTutorial.showCloseButton = strongSelf.showCloseButton
                secondTutorial.customFinalAction = {[weak self] in
                    self?.dismiss(animated: true)
                }
                strongSelf.navigationController?.pushViewController(secondTutorial, animated: true)
            }
            self.navigationController?.pushViewController(viewC, animated: true)
        } else {
            self.dismiss(animated: true)
        }
    }
    
    @objc private func willEnterForeground(){
        if UserDefaultManager.shared.isKeyboardExtensionEnabled(){
            let VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "keyboardEnabledViewControllerID") as! KeyboardEnabledViewController
            VC.fromSettings = self.fromSettings
            VC.showCloseButton = showCloseButton
            self.navigationController?.setViewControllers([VC], animated: true)
        }
    }
    
    @objc private func openSettings(){
        UIApplication.shared.open(URL(string: "App-prefs:General&path=Keyboard/KEYBOARDS")!)
    }
    
    @IBAction func checkboxButtonClicked(_ sender: Any) {
        if isCheckboxSelected{
            checkboxButton.setImage(UIImage(named: "checkboxUnchecked"), for: .normal)
        }else{
            checkboxButton.setImage(UIImage(named: "checkboxChecked"), for: .normal)
        }
        isCheckboxSelected = !isCheckboxSelected
        UserDefaultManager.shared.setBoolValue(key: UserDefaultManager.DONT_SHOW_ENABLE_KEYBOARD_AGAIN_KEY, enabled: isCheckboxSelected)
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
