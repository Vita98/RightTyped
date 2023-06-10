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
        // Initialization code
        
        answerLabel.sizeToFit()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
