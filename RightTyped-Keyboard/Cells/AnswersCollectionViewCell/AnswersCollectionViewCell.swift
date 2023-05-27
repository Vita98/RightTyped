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
        self.backgroundColor = .white
        self.layer.cornerRadius = 5
        
        self.dropShadow(shadowType: .CollectionViewCell)
    }
    
    public func setAnswer(text : String){
        answerLabel.text = text
    }

}
