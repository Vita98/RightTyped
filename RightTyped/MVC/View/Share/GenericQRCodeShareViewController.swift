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
    
    //MARK: Custom variables
    private var qrCodeData: QRCodable?
    private var oldBrightness: CGFloat?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        oldBrightness = UIScreen.main.brightness
        UIScreen.main.brightness = 1
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let oldB = oldBrightness {
            UIScreen.main.brightness = oldB
        }
    }
    
    //MARK: configuration
    private func configure() {
        self.view.backgroundColor = .backgroundColor
        if let data = qrCodeData {
            Task {
                qrCodeImageView.image = await QRCodeHelper.generateQRCode(from: data)
            }
        }
    }
    
    func setQRCodeData(_ data: QRCodable) {
        qrCodeData = data
    }
}
