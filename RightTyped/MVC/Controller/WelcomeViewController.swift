//
//  WelcomeViewController.swift
//  RightTyped
//
//  Created by Vitandrea Sorino on 08/10/23.
//

import UIKit

class WelcomeViewController: UIViewController {

    //MARK: Outlet
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var bottonViewLabel: UILabel!
    @IBOutlet weak var description1Label: UILabel!
    @IBOutlet weak var description2Label: UILabel!
    @IBOutlet weak var welcomeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    //MARK: Configuration
    private func configure(){
        self.view.backgroundColor = .backgroundColor
        bottomView.enableComponentButtonMode()
        bottomView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(goOn)))
        welcomeLabel.text = AppString.WelcomeViewController.title
        description1Label.text = AppString.WelcomeViewController.desc1
        description2Label.text = AppString.WelcomeViewController.desc2
        bottonViewLabel.text = AppString.General.next
    }
    
    //MARK: Event
    @objc private func goOn(){
        let keyboardEnViewContr: EnableKeyboardViewController = UIStoryboard.main().instantiate()
        keyboardEnViewContr.showCloseButton = false
        self.navigationController?.pushViewController(keyboardEnViewContr, animated: true)
    }

}
