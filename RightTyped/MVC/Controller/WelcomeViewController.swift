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
        welcomeLabel.set(text: AppString.WelcomeViewController.title, size: 30)
        description1Label.set(text: AppString.WelcomeViewController.desc1, size: 20)
        description2Label.set(text: AppString.WelcomeViewController.desc2, size: 20)
        bottonViewLabel.set(text: AppString.General.next, size: 24)
    }
    
    //MARK: Event
    @objc private func goOn(){
        let keyboardEnViewContr: EnableKeyboardViewController = UIStoryboard.main().instantiate()
        keyboardEnViewContr.showCloseButton = false
        self.navigationController?.pushViewController(keyboardEnViewContr, animated: true)
    }

}
