//
//  cells.swift
//  RightTyped
//
//  Created by Vitandrea Sorino on 31/05/23.
//

import Foundation
import UIKit

struct CellStyle{
    static let DEFAULT_SELECTED : CellStyle = CellStyle(backgroundColor: .componentColor, textColor: .white, borderColor: .componentColor)
    static let DEFAULT_DESELECTED : CellStyle = CellStyle(backgroundColor: .white, textColor: .black, borderColor: .componentColor)
    
    var backgroundColor: UIColor
    var textColor: UIColor
    var borderColor: UIColor
}

struct CategoryCell{
    var isSelected : Bool
    var selectedStyle : CellStyle
    var deselectedStyle : CellStyle
    
    init(isSelected: Bool, selectedStyle: CellStyle = .DEFAULT_SELECTED, deselectedStyle: CellStyle = .DEFAULT_DESELECTED) {
        self.isSelected = isSelected
        self.selectedStyle = selectedStyle
        self.deselectedStyle = deselectedStyle
    }
}
