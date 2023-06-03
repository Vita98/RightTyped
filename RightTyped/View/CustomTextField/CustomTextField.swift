//
//  CustomTextField.swift
//  RightTyped
//
//  Created by Vitandrea Sorino on 03/06/23.
//

import UIKit

class CustomTextField: UIView, UITextFieldDelegate {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var editButton: UIButton!
        
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
    }
    
    @objc func buttonPressed(){
        if isEditing{
            textFieldDidEndEditing(textField)
        }else{
            isEditing = true
            setEditingMode(enabled: true)
        }
    }
    
    internal func textFieldDidEndEditing(_ textField: UITextField) {
        setEditingMode(enabled: false)
        currentText = textField.text
        isEditing = false
        endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textFieldDidEndEditing(textField)
        return false
    }
    
    
    
    private func toggleBorder(enabled : Bool){
        if enabled{
            self.contentView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
            self.contentView.layer.borderWidth = 0.5
            self.contentView.layer.cornerRadius = 7
        }else{
            self.contentView.layer.borderColor = .none
            self.contentView.layer.borderWidth = 0
            self.contentView.layer.cornerRadius = 7
        }
    }
    
    private func setEditingMode(enabled : Bool){
        if !enabled {
            toggleBorder(enabled: false)
            textField.isHidden = true
            label.isHidden = false
        }else{
            self.textField.becomeFirstResponder()
            toggleBorder(enabled: true)
            textField.isHidden = false
            label.isHidden = true
        }
    }
    
    
    public func inizalize(inView view : UIView, withText text: String = "", placheolder: String? = nil){
        setUp(inView: view)
        
        textField.placeholder = placheolder
        currentText = text
        
        setEditingMode(enabled: false)
    }

}
