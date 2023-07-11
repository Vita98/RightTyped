//
//  KeyboardEnabledViewController.swift
//  RightTyped
//
//  Created by Vitandrea Sorino on 06/06/23.
//

import UIKit

class KeyboardEnabledViewController: UIViewController {

    @IBOutlet weak var doneButtonView: UIView!
    @IBOutlet weak var closeButton: UIButton!
    
    var fromSettings = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        closeButton.setTitle("", for: .normal)
        self.view.backgroundColor = .backgroundColor
        doneButtonView.enableComponentButtonMode()
        doneButtonView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(doneButtonViewPressed)))
    }
    
    @objc private func doneButtonViewPressed(){
        closeView()
    }
    
    @IBAction func closeButtonAction(_ sender: Any) {
        closeView()
    }
    
    private func closeView(){
        if fromSettings{
            self.dismiss(animated: true)
        }else{
            SceneDelegate.goToHome(animated: true)
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
