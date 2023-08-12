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
    @IBOutlet weak var nextLabel: UILabel!
    
    var fromSettings = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        closeButton.setTitle("", for: .normal)
        self.view.backgroundColor = .backgroundColor
        doneButtonView.enableComponentButtonMode()
        doneButtonView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(doneButtonViewPressed)))
        nextLabel.text = fromSettings ? AppString.General.done : AppString.General.next
    }
    
    @objc private func doneButtonViewPressed(){
        if fromSettings{
            closeView()
        }else{
            let viewC: ManagerTutorialViewController = UIStoryboard.main().instantiate(ManagerTutorialViewController.self)
            viewC.model = Tutorials.HOW_TO_USE_KEYBOARD
            viewC.fromSettings = self.fromSettings
            viewC.customFinalAction = {[weak self] in
                //Implement the second tutorial
                guard let strongSelf = self else { return }
                let secondTutorial: ManagerTutorialViewController = UIStoryboard.main().instantiate(ManagerTutorialViewController.self)
                secondTutorial.model = Tutorials.HOW_TO_CUSTOMIZE_KEYBOARD
                secondTutorial.fromSettings = strongSelf.fromSettings
                secondTutorial.isFinalTutorial = true
                secondTutorial.customFinalAction = {[weak self] in
                    self?.dismiss(animated: true)
                }
                strongSelf.navigationController?.pushViewController(secondTutorial, animated: true)
            }
            self.navigationController?.pushViewController(viewC, animated: true)
        }
    }
    
    @IBAction func closeButtonAction(_ sender: Any) {
        closeView()
    }
    
    private func closeView(){
        self.dismiss(animated: true)
    }

}
