//
//  GenericQRCodeShareViewController.swift
//  RightTyped
//
//  Created by Vitandrea Sorino on 19/11/23.
//

import UIKit

class GenericQRCodeShareViewController: UIViewController {
    
    //MARK: Outlet
    @IBOutlet weak var qrCodeImageView: UIImageView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var bottomLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var activityIndicator: CustomActivityIndicatorView!
    
    //MARK: Custom variables
    private var qrCodeData: QRCodable?
    private var oldBrightness: CGFloat?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let oldB = oldBrightness {
            UIScreen.main.brightness = oldB
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let data = qrCodeData {
            Task {
                let qrcode = await QRCodeHelper.generateQRCode(from: data)
                activityIndicator.stopAnimating()
                UIView.transition(with: qrCodeImageView, duration: 0.5, options: .transitionCrossDissolve, animations: {
                    self.qrCodeImageView.image = qrcode
                    self.oldBrightness = UIScreen.main.brightness
                    UIScreen.main.brightness = 1
                })
            }
        }
    }
    
    //MARK: configuration
    private func configure() {
        containerView.backgroundColor = .backgroundColor
        containerView.applyCustomRoundCorner(10)
        titleLabel.set(text: AppString.General.share, size: 28)
        subtitleLabel.set(text: AppString.Share.frameQrCode, size: 18)
        bottomLabel.set(text: AppString.Share.problemScanningQrCode, size: 18)
        closeButton.setTitle("", for: .normal)
        closeButton.addTarget(self, action: #selector(closeButtonPressed), for: .touchUpInside)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
    }
    
    func setQRCodeData(_ data: QRCodable) {
        qrCodeData = data
    }
    
    //MARK: Events
    @objc private func closeButtonPressed() {
        self.dismiss(animated: true)
    }
}
