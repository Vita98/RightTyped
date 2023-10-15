//
//  CustomTextField.swift
//  RightTyped
//
//  Created by Vitandrea Sorino on 03/06/23.
//

import UIKit

class CustomTextField: UIView, UITextFieldDelegate {

    @IBOutlet private weak var textField: UITextField!
    @IBOutlet private weak var label: UILabel!
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var editButton: UIButton!
    
    public var delegate: CustomComponentDelegate?
    private var isEditing = false
    
    var currentText : String? {
        didSet {
            textField.text = currentText
            label.text = currentText
        }
    }
    
    /// Use this configuration variable to block the icon listener ONLY when in editing mode.
    /// Default value: false
    public var notDismissableAtIconPression = false
    
    /// Enable or disable the border animation when editing
    /// Default value: true
    public var animateBorders = true
    
    /// It allow to stop editing touching over all the component and not only on the icon
    /// Default value: false
    public var startEditingTouchingEverywhere = false
    
    
    //MARK: Configuration
    public func inizalize(inView view : UIView, withText text: String? = nil, placheolder: String? = nil){
        setUp(inView: view)
        
        textField.placeholder = placheolder
        currentText = text
        
        setEditingMode(enabled: false)
    }
    
    private func setUp(inView view: UIView){
        
        view.addSubview(self)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        self.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        self.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        self.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        
        editButton.setTitle("", for: .normal)
        editButton.imageView?.contentMode = .scaleAspectFit
        
        textField.backgroundColor = .none
        textField.borderStyle = .none
        textField.delegate = self
        
        editButton.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        if startEditingTouchingEverywhere { self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(buttonPressed))) }
        
        self.contentView.layer.borderWidth = 0.5
        self.contentView.layer.cornerRadius = 7
        self.contentView.layer.borderColor = animateBorders ? UIColor.clear.cgColor : UIColor.lightGray.withAlphaComponent(0.5).cgColor
    }
    
    //MARK: Events
    @objc private func buttonPressed(){
        if isEditing{
            endEditing(true)
        }else{
            isEditing = true
            if notDismissableAtIconPression { editButton.isUserInteractionEnabled = false }
            setEditingMode(enabled: true)
        }
    }
    
    internal func textFieldDidEndEditing(_ textField: UITextField) {
        if notDismissableAtIconPression { editButton.isUserInteractionEnabled = true }
        disableEditing()
    }
    
    internal func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        disableEditing()
        return false
    }

    func textFieldDidChangeSelection(_ textField: UITextField) {
        currentText = textField.text
        if let currentText = currentText{
            delegate?.didSetNewValue(component: self, newValue: currentText)
        }
    }
    
    //MARK: Private event manager
    private func disableEditing(){
        currentText = textField.text
        setEditingMode(enabled: false)
        isEditing = false
        endEditing(true)
        
        if let currentText = currentText{
            delegate?.didSetNewValue(component: self, newValue: currentText)
        }
    }
    
    private func toggleBorder(enabled : Bool){
        guard animateBorders else { return }
        if enabled{
            self.contentView.animateBorderColor(toColor: UIColor.lightGray.withAlphaComponent(0.5), duration: 0.2)
        }else{
            self.contentView.animateBorderColor(toColor: UIColor.clear, duration: 0.2)
        }
    }
    
    private func setEditingMode(enabled : Bool){
        if !enabled {
            toggleBorder(enabled: false)
            
            if let text = currentText{
                if text.isEmpty{
                    textField.isEnabled = false
                    label.isHidden = true
                }else{
                    textField.isHidden = true
                    label.isHidden = false
                }
            }else{
                textField.isEnabled = false
                label.isHidden = true
            }
        }else{
            toggleBorder(enabled: true)
            textField.isHidden = false
            textField.isEnabled = true
            label.isHidden = true
            self.textField.becomeFirstResponder()
        }
    }
    
    public func showError(animated: Bool = true){
        if animated{
            self.contentView.animateBorderColor(toColor: UIColor.red, duration: 0.2)
        }else{
            self.contentView.layer.borderColor = UIColor.red.cgColor
        }
    }
}
