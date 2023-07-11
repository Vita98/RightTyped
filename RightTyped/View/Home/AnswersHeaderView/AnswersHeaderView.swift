//
//  AnswersHeaderView.swift
//  RightTyped
//
//  Created by Vitandrea Sorino on 31/05/23.
//

import UIKit

class AnswersHeaderView: UIView {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var gradientView: UIView!
    static let NIB_NAME = "AnswersHeaderView"

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    public func configureCell(){
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.white.cgColor,UIColor.white.withAlphaComponent(0.90).cgColor, UIColor.white.withAlphaComponent(0.85).cgColor]
        gradient.type = .axial
        gradient.locations = [0.0,0.5,1.0]
        gradient.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradient.endPoint = CGPoint(x: 0.5, y: 0.5)
        gradient.frame = gradientView.frame
        gradientView.layer.insertSublayer(gradient, at: 0)

        //Configuring the search bar
        searchBar.placeholder = AppString.General.answerSearchBarPlaceholder
        searchBar.tintColor = .none
        searchBar.barTintColor = .none
        searchBar.backgroundColor = .none
        searchBar.backgroundImage = UIImage()
        if let textfield = searchBar.value(forKey: "searchField") as? UITextField {
            textfield.backgroundColor = .lightComponentColor
            textfield.attributedPlaceholder = NSAttributedString(string: textfield.placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor : UIColor.placeholderColor])
            textfield.leftView?.tintColor = .placeholderColor
        }
    }
    
    public func setSearchBarStatus(enabled: Bool){
        if enabled{
            if let textfield = searchBar.value(forKey: "searchField") as? UITextField {
                textfield.attributedPlaceholder = NSAttributedString(string: textfield.placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor : UIColor.placeholderColor])
                textfield.leftView?.tintColor = .placeholderColor
            }
            searchBar.isUserInteractionEnabled = true
        }else{
            searchBar.text = ""
            if let textfield = searchBar.value(forKey: "searchField") as? UITextField {
                textfield.attributedPlaceholder = NSAttributedString(string: textfield.placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor : UIColor.placeholderColor.withAlphaComponent(0.2)])
                textfield.leftView?.tintColor = .placeholderColor.withAlphaComponent(0.2)
            }
            searchBar.isUserInteractionEnabled = false
        }
    }

}
