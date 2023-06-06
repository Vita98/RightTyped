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
    @IBOutlet weak var checkboxButton: UIButton!
    
    var isCheckboxSelected: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.view.backgroundColor = .backgroundColor
        closeButton.setTitle("", for: .normal)
        checkboxButton.setTitle("", for: .normal)
        openSettingsView.enableComponentButtonMode()
        keyboardNotEnabledView.enableComponentButtonMode(enabled: false)
        openSettingsView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openSettings)))
        
        // set observer for UIApplication.willEnterForegroundNotification
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    deinit{
        NotificationCenter.default.removeObserver(self)
    }
    
    
    @IBAction func closeButtonPression(_ sender: Any) {
        SceneDelegate.goToHome()
    }
    
    @objc private func willEnterForeground(){
        print("Ciao")
        if AppDelegate.isKeyboardExtensionEnabled{
            let VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "keyboardEnabledViewControllerID") as! KeyboardEnabledViewController
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
