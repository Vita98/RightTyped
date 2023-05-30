//
//  AnswersCollectionViewCell.swift
//  RightTyped-Keyboard
//
//  Created by Vitandrea Sorino on 27/05/23.
//

import UIKit

class AnswersCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var answerLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    public func configureCell(){
        self.layer.cornerRadius = 5        
        self.dropShadow(shadowType: .CollectionViewCell)
    }
    
    public func setAnswer(text : String){
        answerLabel.text = text
    }
    
    public func textDidChange(appearance: UIKeyboardAppearance){
        if appearance == .light{
            answerLabel.textColor = .cellTextLightColor
            self.backgroundColor = .cellLightBackgroudColor
        }else{
            answerLabel.textColor = .cellTextlDarkColor
            self.backgroundColor = .cellDarkBackgroudColor
        }
    }

}