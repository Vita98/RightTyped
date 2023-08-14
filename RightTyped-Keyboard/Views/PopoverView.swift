//
//  PopoverView.swift
//  RightTyped-Keyboard
//
//  Created by Vitandrea Sorino on 19/06/23.
//

import UIKit

class PopoverView: UIView {
    
    var keyboardAppearance : UIKeyboardAppearance?
    var hideView: UIView?
    
    private var label: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    
    //MARK: Initialization
    private override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(frame: CGRect, keyboardAppearance: UIKeyboardAppearance?) {
        self.init(frame: frame)
        self.keyboardAppearance = keyboardAppearance
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: Configuration
    private func setLayout(){
        self.addSubview(label)
        label.setFloodConstrait(in: self, leading: 10, trailing: -10)
        self.alpha = 0
    }
    
    public func setIn(_ view: UIView){
        view.addSubview(self)
        setFloodConstrait(in: view)
    }
    
    public func setText(_ text: String){
        label.text = text
    }
    
    //MARK: Presentation
    public func show(withAnimation: Bool = true, hideView: UIView? = nil){
        if withAnimation{
//            let fg = UIImpactFeedbackGenerator()
//            fg.impactOccurred(intensity: 1)
            UIView.animate(withDuration: 0.2) {
                self.alpha = 1
                self.hideView = hideView
                if let hideView = hideView{
                    hideView.alpha = 0.2
                }
            }
        }else{
            self.alpha = 1
        }
    }
    
    public func removeFromSuperviewWithAnimation(){
//        let fg = UIImpactFeedbackGenerator()
//        fg.impactOccurred(intensity: 1)
        UIView.animate(withDuration: 0.2) {
            self.alpha = 0
            if let hideView = self.hideView{
                hideView.alpha = 1
            }
        } completion: { isDone in
            self.removeFromSuperview()
        }
    }

}
