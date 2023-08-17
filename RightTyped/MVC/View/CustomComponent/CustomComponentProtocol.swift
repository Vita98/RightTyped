//
//  CustomComponentProtocol.swift
//  RightTyped
//
//  Created by Vitandrea Sorino on 13/06/23.
//

import Foundation
import UIKit

protocol CustomComponentDelegate{
    func didSetNewValue(component: UIView, newValue: String)
}
