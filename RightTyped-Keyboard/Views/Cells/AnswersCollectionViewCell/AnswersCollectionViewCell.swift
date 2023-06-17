//
//  AnswersCollectionViewCell.swift
//  RightTyped-Keyboard
//
//  Created by Vitandrea Sorino on 27/05/23.
//

import UIKit

class AnswersCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var answerLabel: UILabel!
    public var delegate: AnswerCollectionViewCellDelegate?
    
    private var selectedAnswer: Answer? {
        didSet{
            answerLabel.text = selectedAnswer!.title
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    public func configureCell(){
        self.layer.cornerRadius = 5        
        self.dropShadow(shadowType: .collectionViewCell)
        
        answerLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(labelTouchUpInside)))
        answerLabel.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(labelLongPress)))
    }
    
    public func setAnswer(_ answer: Answer){
        selectedAnswer = answer
    }
    
    
    //MARK: Events
    public func textDidChange(appearance: UIKeyboardAppearance){
        if appearance == .light{
            answerLabel.textColor = .cellTextLightColor
            self.backgroundColor = .cellLightBackgroudColor
        }else{
            answerLabel.textColor = .cellTextlDarkColor
            self.backgroundColor = .cellDarkBackgroudColor
        }
    }
    
    @objc private func labelTouchUpInside(){
        guard let answer = selectedAnswer else { return }
        delegate?.answerCollectionViewCellTouchUpInside(withAnswer: answer)
    }
    
    @objc private func labelLongPress(gestureReconizer: UILongPressGestureRecognizer){
        if gestureReconizer.state == .began{
            guard let answer = selectedAnswer else { return }
            delegate?.answerCollectionViewCellLongPress(withAnswer: answer)
        }
    }

}

public protocol AnswerCollectionViewCellDelegate {
    func answerCollectionViewCellTouchUpInside(withAnswer answer: Answer)
    func answerCollectionViewCellLongPress(withAnswer answer: Answer)
}
