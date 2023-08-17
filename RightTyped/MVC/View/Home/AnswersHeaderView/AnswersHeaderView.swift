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
    private var gradient: CAGradientLayer?
    
    //MARK: - Lifecycle
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        switch traitCollection.userInterfaceStyle{
        case .dark:
            if let gradient = gradient{
                gradient.removeFromSuperlayer()
            }
            gradientView.backgroundColor = .black
        case .light:
            gradientView.backgroundColor = .none
            if let gradient = gradient{
                gradientView.layer.insertSublayer(gradient, at: 0)
            }else{
                configureGradient()
            }
            break
        case .unspecified:
            break
        @unknown default:
            break
        }
    }
    
    //MARK: - Configuration
    public func configureCell(){
        configureGradient()

        //Configuring the search bar
        searchBar.placeholder = AppString.General.answerSearchBarPlaceholder
        searchBar.tintColor = .none
        searchBar.barTintColor = .none
        searchBar.backgroundColor = .none
        searchBar.backgroundImage = UIImage()
        if let textfield = searchBar.value(forKey: "searchField") as? UITextField {
            textfield.backgroundColor = .lightComponentColor
            textfield.attributedPlaceholder = NSAttributedString(string: textfield.placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor : UIColor.placeholderColor ?? .white])
            textfield.leftView?.tintColor = .placeholderColor
        }
    }
    
    public func configureGradient(){
        if traitCollection.userInterfaceStyle == .light{
            let gradient = CAGradientLayer()
            gradient.colors = [UIColor.white.cgColor,UIColor.white.withAlphaComponent(0.90).cgColor, UIColor.white.withAlphaComponent(0.85).cgColor]
            gradient.type = .axial
            gradient.locations = [0.0,0.5,1.0]
            gradient.startPoint = CGPoint(x: 0.5, y: 0.0)
            gradient.endPoint = CGPoint(x: 0.5, y: 0.5)
            gradient.frame = gradientView.frame
            gradientView.layer.insertSublayer(gradient, at: 0)
            self.gradient = gradient
        }else{
            gradientView.backgroundColor = .black
        }
    }
    
    public func setSearchBarStatus(enabled: Bool){
        if enabled{
            if let textfield = searchBar.value(forKey: "searchField") as? UITextField {
                textfield.attributedPlaceholder = NSAttributedString(string: textfield.placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor : UIColor.placeholderColor ?? .white])
                textfield.leftView?.tintColor = .placeholderColor
            }
            searchBar.isUserInteractionEnabled = true
        }else{
            searchBar.text = ""
            if let textfield = searchBar.value(forKey: "searchField") as? UITextField {
                textfield.attributedPlaceholder = NSAttributedString(string: textfield.placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor : UIColor.placeholderColor?.withAlphaComponent(0.2) ?? .white])
                textfield.leftView?.tintColor = .placeholderColor?.withAlphaComponent(0.2)
            }
            searchBar.isUserInteractionEnabled = false
        }
    }
}
