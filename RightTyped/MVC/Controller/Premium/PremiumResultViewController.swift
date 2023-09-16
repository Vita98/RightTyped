//
//  PremiumResultViewController.swift
//  RightTyped
//
//  Created by Vitandrea Sorino on 16/09/23.
//

import UIKit

class PremiumResultViewController: UIViewController {
    
    enum ResultType{
        case success
        case failure
    }

    //MARK: - Outlet
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var bottomView: UIView!
    @IBOutlet private weak var bottomViewLabel: UILabel!
    @IBOutlet private weak var iconImageView: UIImageView!
    @IBOutlet private weak var contentLabel: UILabel!
    
    //MARK: - Variables
    private var result: ResultType?
    private var product: Products?
    public var closeClosure: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
    }
    
    //MARK: - Configuration
    private func configure(){
        self.contentView.layer.cornerRadius = MODAL_VIEW_ROUND_CORNER
        bottomView.enableComponentButtonMode()
        bottomView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(closeButtonPressed)))
        bottomViewLabel.text = AppString.General.close
        
        switch result{
        case .success:
            iconImageView.image = UIImage(named: "tickIcon")
            if product == .YearlyProPlan{
                contentLabel.text = AppString.Premium.Popup.SuccessPro.description
                titleLabel.text = AppString.Premium.Popup.SuccessPro.title
            }else{
                contentLabel.text = AppString.Premium.Popup.SuccessPpu.description
                titleLabel.text = AppString.Premium.Popup.SuccessPpu.title
            }
        case .failure:
            iconImageView.image = UIImage(named: "warningIcon")
            contentLabel.text = AppString.Premium.Popup.Failure.description
            titleLabel.text = AppString.Premium.Popup.Failure.title
        case .none:
            break
        }
    }
    
    public func configure(for result: ResultType, with product: Products, _ closeAction: (() -> Void)? = nil){
        self.result = result
        self.product = product
        if closeAction != nil { self.closeClosure = closeAction }
    }
    
    //MARK: - Events
    @objc private func closeButtonPressed(){
        self.dismiss(animated: true)
        if result == .success { closeClosure?() }
    }
}
