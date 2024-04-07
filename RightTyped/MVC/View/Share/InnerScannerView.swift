//
//  InnerScannerView.swift
//  RightTyped
//
//  Created by Vitandrea Sorino on 05/04/24.
//

import UIKit

class InnerScannerView: UIView {
    //MARK: Outlet
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var overlayView: UIView!
    @IBOutlet weak var qrCodeScanBoxImageView: UIImageView!
    @IBOutlet weak var leadingBoxImageViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var frameQrLabel: UILabel!
    @IBOutlet weak var flashImageView: UIImageView!
}
