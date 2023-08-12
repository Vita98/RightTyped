//
//  FinalTutorialViewController.swift
//  RightTyped
//
//  Created by Vitandrea Sorino on 12/08/23.
//

import UIKit

class FinalTutorialViewController: UIViewController {
    
    // MARK: - Outlet
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bottomLabel: UILabel!
    @IBOutlet weak var bottomView: UIView!
    
    var customPressionAction: (() -> Void)?
    
    var fromSettings: Bool = false
    var isFinal: Bool = false
    var model: TutorialPageModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        bottomView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(bottomViewButtonPressed)))
        bottomView.enableComponentButtonMode()
        configure()
    }
    
    // MARK: - Utility
    private func configure(){
        guard let model = model, model.final, model.stackContent.count == 1, model.stackContent.first?.type == .text else { return }
        titleLabel.text = model.stackContent.first?.content
        bottomLabel.text = fromSettings || isFinal ? AppString.General.done : AppString.General.next
    }
    
    private func buttonPressedAction(){
        if fromSettings{
            self.dismiss(animated: true)
        }else{
            customPressionAction?()
        }
    }
    
    // MARK: - Event
    @objc private func bottomViewButtonPressed(){
        buttonPressedAction()
    }

}
