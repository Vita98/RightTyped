//
//  Constants.swift
//  RightTyped-Keyboard
//
//  Created by Vitandrea Sorino on 27/05/23.
//

import Foundation
import UIKit

let CATEGORY_TABLE_VIEW_CELL_HEIGHT: CGFloat = 90
let GLOBE_ICON_SIZE: CGSize = CGSize(width: 35, height: 35)
let FOOTER_VIEW_HEIGHT: CGFloat = 60



// TODO: remove and implement core data to manage the category and answers
let NUMBER_OF_CATEGORY : Int = 4
let ANSWERS : [String] = [" Che bellooooo ", "CAoaoaoaooaoaoaoaoao", "Prova di una lunga cella", "Ciao"]
var NUMBER_OF_ANSWERS : Int {
    get{
        return ANSWERS.count
    }
}
