//
//  PlainPremiumViewController.swift
//  RightTyped
//
//  Created by Vitandrea Sorino on 05/09/23.
//

import UIKit

class PlainPremiumViewController: UIViewController {
    
    var model: PremiumPageModel?{
        didSet{
            configureModel()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    //MARK: - Configuration
    private func configureModel(){
        
    }
}
