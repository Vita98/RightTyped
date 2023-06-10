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
        
    var currentText : String? {
        didSet {
            textField.text = currentText
            label.text = currentText
        }
    }
    
    private var isEditing = false
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
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
        
        self.contentView.layer.borderWidth = 0.5
        self.contentView.layer.cornerRadius = 7
        self.contentView.layer.borderColor = UIColor.clear.cgColor
    }
    
    @objc private func buttonPressed(){
        if isEditing{
            endEditing(true)
        }else{
            isEditing = true
            setEditingMode(enabled: true)
        }
    }
    
    private func disableEditing(){
        currentText = textField.text
        setEditingMode(enabled: false)
        isEditing = false
        endEditing(true)
    }
    
    internal func textFieldDidEndEditing(_ textField: UITextField) {
        disableEditing()
    }
    
    internal func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        disableEditing()
        return false
    }
    
    
    
    private func toggleBorder(enabled : Bool){
        if enabled{
            self.contentView.animateBorderColor(toColor: UIColor.lightGray.withAlphaComponent(0.5), duration: 0.2)
        }else{
            self.contentView.animateBorderColor(toColor: UIColor.clear, duration: 0.2)
        }
    }
    
    private func setEditingMode(enabled : Bool){
        if !enabled {
            toggleBorder(enabled: false)
            
            if let text = currentText, text.isEmpty{
                textField.isEnabled = false
            }else{
                textField.isHidden = true
            }
            label.isHidden = false
        }else{
            self.textField.becomeFirstResponder()
            toggleBorder(enabled: true)
            textField.isHidden = false
            textField.isEnabled = true
            label.isHidden = true
        }
    }
    
    
    public func inizalize(inView view : UIView, withText text: String? = nil, placheolder: String? = nil){
        setUp(inView: view)
        
        textField.placeholder = placheolder
        currentText = text
        
        setEditingMode(enabled: false)
    }

}
