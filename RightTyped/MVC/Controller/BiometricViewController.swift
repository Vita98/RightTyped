//
//  BiometricViewController.swift
//  RightTyped
//
//  Created by Vitandrea Sorino on 16/08/23.
//

import UIKit

class BiometricViewController: UIViewController {
    
    //MARK: - Outlet
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var bottomLabel: UILabel!
    @IBOutlet weak var middleLabel: UILabel!
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        biometricRequest()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    //MARK: - Configuration
    private func configure(){
        self.view.backgroundColor = .backgroundColor
        self.bottomView.enableComponentButtonMode()
        bottomView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(bottomViewPressed)))
        bottomLabel.set(size: 24)
        middleLabel.set(size: 20)
        
        let biomType: String? = BiometricHelper.biometricType()
        if let biomType = biomType{
            bottomLabel.text = String(format: AppString.BiometricViewController.buttonText, biomType)
            middleLabel.text = String(format: AppString.BiometricViewController.middleMessage, biomType)
        }
    }
    
    private func biometricRequest(){
        BiometricHelper.askForBiometric { isSuccessful, error in
            if isSuccessful{
                SceneDelegate.goToHome(animated: true)
            }
        }
    }
    
    //MARK: - Events
    @objc private func bottomViewPressed(){
        biometricRequest()
    }

}
