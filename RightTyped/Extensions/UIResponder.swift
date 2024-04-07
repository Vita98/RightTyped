//
//  UIResponder.swift
//  RightTyped
//
//  Created by Vitandrea Sorino on 05/04/24.
//

import Foundation
import UIKit

extension UIResponder {
    public var parentViewController: UIViewController? {
        return next as? UIViewController ?? next?.parentViewController
    }
}
