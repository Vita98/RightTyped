//
//  SelectablePremiumViewController.swift
//  RightTyped
//
//  Created by Vitandrea Sorino on 07/09/23.
//

import UIKit

class SelectablePremiumViewController: UIViewController {
    
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
