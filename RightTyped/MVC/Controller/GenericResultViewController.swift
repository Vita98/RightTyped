//
//  GenericResultViewController.swift
//  RightTyped
//
//  Created by Vitandrea Sorino on 23/09/23.
//

import UIKit

class GenericResultViewController: UIViewController {

    //MARK: - Outlet
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var iconImageView: UIImageView!
    @IBOutlet private weak var contentLabel: UILabel!
    @IBOutlet weak var buttonsContainerView: UIView!
    @IBOutlet weak var buttonsContainerViewHeightConstraint: NSLayoutConstraint!
    
    //MARK: Custom variables
    private var buttons : [UIView] = []
    private var buttonsClosure : [() -> Void] = []
    private var iconImage: UIImage?
    private var titleText: String?
    private var descriptionText: String?
    
    //MARK: - Custom global config
    public var withCloseButton: Bool = false {
        didSet{
            guard withCloseButton else { return }
            addButton(withText: AppString.General.close){[weak self] in
                self?.dismiss(animated: true)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    //MARK: - Configure
    private func configure(){
        self.contentView.layer.cornerRadius = MODAL_VIEW_ROUND_CORNER
        self.iconImageView.image = iconImage
        
        if titleText == nil {
            titleLabel.removeFromSuperview()
            contentLabel.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: 20).isActive = true
        }
        
        titleLabel.text = titleText
        contentLabel.text = descriptionText
        titleLabel.set(size: 24)
        contentLabel.set(size: 18)
        var previous: UIView? = nil
        
        for (v,i) in zip(buttons, 0..<buttons.count){
            buttonsContainerView.addSubview(v)
            v.trailingAnchor.constraint(equalTo: buttonsContainerView.trailingAnchor, constant: -20).isActive = true
            v.leadingAnchor.constraint(equalTo: buttonsContainerView.leadingAnchor, constant: 20).isActive = true
            
            if previous == nil{ v.topAnchor.constraint(equalTo: buttonsContainerView.topAnchor).isActive = true }
            else { v.topAnchor.constraint(equalTo: previous!.bottomAnchor, constant: 15).isActive = true }
            
            if i == buttons.count - 1 { v.bottomAnchor.constraint(equalTo: buttonsContainerView.bottomAnchor).isActive = true }
            previous = v
        }
        buttonsContainerView.removeConstraint(buttonsContainerViewHeightConstraint)
    }
    
    public func configure(image: UIImage? = nil, title: String? = nil, description: String? = nil, buttons: [String] = [], closures: [() -> Void] = []){
        iconImage = image
        titleText = title
        descriptionText = description
        self.buttons = []
        self.buttonsClosure = closures
        for (b,i) in zip(buttons, 0..<buttons.count){
            if i < closures.count{
                addButton(withText: b, closures[i])
            }else{
                addButton(withText: b)
            }
        }
    }
    
    public func addButton(withText text: String, _ action: (() -> Void)? = nil){
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        let lab = UILabel()
        lab.text = text
        lab.textColor = .white
        lab.textAlignment = .center
        lab.font = UIFont.customFont(.normal, size: 24)
        v.addSubview(lab)
        lab.translatesAutoresizingMaskIntoConstraints = false
        lab.topAnchor.constraint(equalTo: v.topAnchor).isActive = true
        lab.leadingAnchor.constraint(equalTo: v.leadingAnchor).isActive = true
        lab.trailingAnchor.constraint(equalTo: v.trailingAnchor).isActive = true
        lab.bottomAnchor.constraint(equalTo: v.bottomAnchor).isActive = true
        v.enableComponentButtonMode()
        v.heightAnchor.constraint(equalToConstant: 50).isActive = true
        v.addTapGestureRecognizer(action: action)
        self.buttons.append(v)
    }
}
