//
//  CustomTextArea.swift
//  RightTyped
//
//  Created by Vitandrea Sorino on 04/06/23.
//

import UIKit

class CustomTextArea: UIView, UITextViewDelegate {

    @IBOutlet private weak var placeholderLabel: UILabel!
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var editButton: UIButton!
    @IBOutlet private weak var textView: UITextView!
    
    public var delegate: CustomComponentDelegate?
    private var isEditing : Bool = false
    
    var currentText : String? {
        didSet {
            textView.text = currentText
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
        
        if let p = placheolder, !p.isEmpty{
            placeholderLabel.text = p
        }
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
        
        textView.sizeToFit()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.delegate = self
        textView.text = ""
        textView.set(size: 18)
        
        editButton.setTitle("", for: .normal)
        editButton.imageView?.contentMode = .scaleAspectFit
        
        editButton.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        if startEditingTouchingEverywhere {
            textView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(buttonPressed)))
            self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(buttonPressed)))
            placeholderLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(buttonPressed)))
        }
        
        self.contentView.layer.borderWidth = 0.5
        self.contentView.layer.cornerRadius = 7
        self.contentView.layer.borderColor = animateBorders ? UIColor.clear.cgColor : UIColor.lightGray.withAlphaComponent(0.5).cgColor
        
        placeholderLabel.isHidden = true
        placeholderLabel.set(size: 18)
    }
    
    //MARK: Events
    @objc private func buttonPressed(sender: Any){
        if isEditing{
            textView.endEditing(true)
        }else{
            isEditing = true
            if notDismissableAtIconPression { editButton.isUserInteractionEnabled = false }
            setEditingMode(enabled: true)
        }
    }
    
    internal func textViewDidEndEditing(_ textView: UITextView) {
        if notDismissableAtIconPression { editButton.isUserInteractionEnabled = true }
        disableEditing()
    }
    
    func textViewDidChange(_ textView: UITextView) {
        currentText = textView.text
        if let currentText = currentText{
            delegate?.didSetNewValue(component: self, newValue: currentText)
        }
    }
    
    //MARK: Private event manager
    private func disableEditing(){
        currentText = textView.text
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
            textView.isEditable = false
            
            if let text = currentText, !text.isEmpty{
                placeholderLabel.isHidden = true
            }else{
                placeholderLabel.isHidden = false
            }
        }else{
            textView.isEditable = true
            placeholderLabel.isHidden = true
            textView.becomeFirstResponder()
            toggleBorder(enabled: true)
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
