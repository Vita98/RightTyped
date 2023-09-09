//
//  CustomActivityIndicatorView.swift
//  RightTyped
//
//  Created by Vitandrea Sorino on 09/09/23.
//

import UIKit

class CustomActivityIndicatorView: UIActivityIndicatorView {

    required init(coder: NSCoder) {
        super.init(coder: coder)
        self.color = .componentColor
    }

}
