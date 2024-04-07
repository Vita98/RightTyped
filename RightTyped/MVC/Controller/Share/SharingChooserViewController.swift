//
//  SharingChooserViewController.swift
//  RightTyped
//
//  Created by Vitandrea Sorino on 25/11/23.
//

import UIKit

class SharingChooserViewController: UIViewController {
    
    //MARK: Outlet
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var qrCodeContentView: UIView!
    @IBOutlet weak var fileContentView: UIView!
    @IBOutlet weak var qrCodeShadowContentView: UIView!
    @IBOutlet weak var fileShadowContentView: UIView!
    @IBOutlet weak var qrCodeLabel: UILabel!
    @IBOutlet weak var fileLabel: UILabel!
    
    //MARK: Variable
    var model: Serializable?
    
    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    override func viewDidLayoutSubviews() {
        qrCodeContentView.clipsToBounds = true
        qrCodeContentView.layer.cornerRadius = 10
        qrCodeShadowContentView.dropShadow(shadowType: .shareCardShadow)
        qrCodeShadowContentView.layer.cornerRadius = 10
        
        fileContentView.clipsToBounds = true
        fileContentView.layer.cornerRadius = 10
        fileShadowContentView.dropShadow(shadowType: .shareCardShadow)
        fileShadowContentView.layer.cornerRadius = 10
    }
    
    //MARK: Configuration
    private func configure() {
        //Listener
        qrCodeContentView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(qrCodePressEvent)))
        fileContentView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(filePressedEvent)))
        
        closeButton.setTitle("", for: .normal)
        self.contentView.layer.cornerRadius = MODAL_VIEW_ROUND_CORNER
        fileContentView.backgroundColor = .backgroundColor?.withAlphaComponent(0.5)
        qrCodeContentView.backgroundColor = .backgroundColor?.withAlphaComponent(0.5)
        fileLabel.textColor = .componentColor
        qrCodeLabel.textColor = .componentColor
        
        //Texts
        titleLabel.set(text: AppString.General.share, size: 28)
        qrCodeLabel.set(text: AppString.Share.qrCode, size: 18)
        fileLabel.set(text: AppString.Share.file, size: 18)
    }
    
    //MARK: Events
    @IBAction func closeButtonAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        if touch?.view != self.contentView && touch?.view?.parentViewController == self {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc private func qrCodePressEvent() {
        let cv: GenericQRCodeShareViewController = UIStoryboard.main().instantiate()
        if let model = model, let qrCodeModel = model as? QRCodable {
            cv.setQRCodeData(qrCodeModel)
        }
        self.present(cv, animated: true)
    }
    
    @objc private func filePressedEvent() {
        
    }
}
