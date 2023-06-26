//
//  AddAnswerCustomView.swift
//  RightTyped
//
//  Created by Vitandrea Sorino on 25/06/23.
//

import UIKit

class AddAnswerCustomView: UIView {

    //MARK: Component
    private let backgroundImageView: UIImageView = {
        return UIImageView(image: UIImage(named: "addAnswerBackground"))
    }()
    
    private let addIconImageView: UIImageView = {
        let imgView = UIImageView(image: UIImage(named: "addIcon"))
        imgView.contentMode = .scaleAspectFit
        return imgView
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.text = "Risposta"
        label.font = UIFont(name: "Trakya Rounded 300 Light", size: 8)
        label.textColor = .componentColor
        label.textAlignment = .center
        return label
    }()
    
    private let leftArrowImageView: UIImageView = {
        let imgView = UIImageView(image: UIImage(named: "backIcon")?.withTintColor(.componentColor))
        imgView.contentMode = .center
        return imgView
    }()
    
    
    //MARK: Status variables
    private var status: AddAnswerCustomView.Status = .opened
    private var enabled: Bool = true
    private var originalFrame: CGRect?
    private var customTapAction: (() -> Void)?
    
    private var trailingConstraint: NSLayoutConstraint?
    
    
    //MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }
    
    init(inside view: UIView) {
        super.init(frame:.zero)
        
        view.addSubview(self)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.heightAnchor.constraint(equalToConstant: 80).isActive = true
        self.widthAnchor.constraint(equalToConstant: 50).isActive = true
        trailingConstraint = self.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        trailingConstraint?.isActive = true
        self.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -150).isActive = true
        configure()
    }
    
    
    //MARK: Configuration
    private func configure(){
        addBackgroundView()
        addIconAndLabel()
        addLeftArrowImageView()
        
        //gestures
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapGesture(gesture:))))
    }
    
    private func addLeftArrowImageView(){
        self.insertSubview(leftArrowImageView, belowSubview: addIconImageView)
        leftArrowImageView.translatesAutoresizingMaskIntoConstraints = false
        leftArrowImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
        leftArrowImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        leftArrowImageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        leftArrowImageView.alpha = 0
    }
    
    private func addIconAndLabel(){
        self.addSubview(addIconImageView)
        addIconImageView.translatesAutoresizingMaskIntoConstraints = false
        addIconImageView.heightAnchor.constraint(equalToConstant: 22).isActive = true
        addIconImageView.widthAnchor.constraint(equalToConstant: 22).isActive = true
        addIconImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 3).isActive = true
        addIconImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -7).isActive = true
        
        //label
        self.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.centerXAnchor.constraint(equalTo: addIconImageView.centerXAnchor).isActive = true
        label.topAnchor.constraint(equalTo: addIconImageView.bottomAnchor, constant: 3).isActive = true
    }
    
    private func addBackgroundView(){
        self.addSubview(backgroundImageView)
        backgroundImageView.setFloodConstrait(in: self)
        backgroundImageView.dropShadow(shadowType: .contentView)
    }
    
    private func setStatus(status: AddAnswerCustomView.Status){
        if status == .closed{
            self.status = .closed
            self.frame = CGRect(x: self.frame.minX+(self.frame.width/2), y: self.frame.minY, width: self.frame.width, height: self.frame.height)
            trailingConstraint?.constant = 25
            self.addIconImageView.alpha = 0
            self.label.alpha = 0
            self.leftArrowImageView.alpha = 1
        } else if status == .opened, let originalFrame = originalFrame{
            self.status = .opened
            self.frame = originalFrame
            trailingConstraint?.constant = 0
            self.addIconImageView.alpha = 1
            self.label.alpha = 1
            self.leftArrowImageView.alpha = 0
        }
    }
    
    private func setEnabled(_ enabled: Bool){
        self.enabled = enabled
        
        UIView.animate(withDuration: 0.3) {
            if enabled{
                self.addIconImageView.image = UIImage(named: "addIcon")
                self.label.isEnabled = true
                self.leftArrowImageView.image = UIImage(named: "backIcon")
            }else{
                self.addIconImageView.image = self.addIconImageView.image?.withTintColor(.lightGray)
                self.label.isEnabled = false
                self.leftArrowImageView.image = self.leftArrowImageView.image?.withTintColor(.lightGray)
            }
        }
    }
    
    
    //MARK: event
    @objc private func tapGesture(gesture: UITapGestureRecognizer){
        guard enabled else { return }
        
        if status == .closed{
            self.setStatus(status: .opened, withAnimation: true)
        }else{
            customTapAction?()
        }
    }
    
    
    //MARK: Public configurations
    public func setCustomTapAction(action: @escaping (() -> Void)){
        customTapAction = action
    }
    
    public func setStatus(status: AddAnswerCustomView.Status, withAnimation animation: Bool){
        guard enabled else { return }
        
        if originalFrame == nil{
            originalFrame = self.frame
        }
        
        if animation{
            UIView.animate(withDuration: 0.3) {
                self.setStatus(status: status)
            }
        }else{
            self.setStatus(status: status)
        }
    }
    
    public var isEnabled: Bool {
        set{
            if newValue != self.enabled{
                setEnabled(newValue)
            }
        }
        get{
            return self.enabled
        }
    }
    
    public var isOpened: Bool {
        get{
            return self.status == .opened
        }
    }
    
}

extension AddAnswerCustomView{
    enum Status{
        case opened
        case closed
    }
}
