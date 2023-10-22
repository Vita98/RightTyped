//
//  AnswerTableViewCell.swift
//  RightTyped
//
//  Created by Vitandrea Sorino on 29/05/23.
//

import UIKit

class AnswerTableViewCell: UITableViewCell {
    
    public static var reuseID = "answerTableViewCellID"

    @IBOutlet weak var answerLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        answerLabel.sizeToFit()
        answerLabel.set(size: 18)
    }
}
