//
//  CustomTextArea.swift
//  RightTyped
//
//  Created by Vitandrea Sorino on 04/06/23.
//

import UIKit

class CustomTextArea: UIView, UITextViewDelegate {

    @IBOutlet weak var placeholderLabel: UILabel!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var textView: UITextView!
    
    var isEditing : Bool = false
    var currentText : String?
    
    
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
        
        editButton.setTitle("", for: .normal)
        editButton.imageView?.contentMode = .scaleAspectFit
        
        editButton.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        
        self.contentView.layer.borderWidth = 0.5
        self.contentView.layer.cornerRadius = 7
        self.contentView.layer.borderColor = UIColor.clear.cgColor
        
        placeholderLabel.isHidden = true
        
    }
    
    @objc func buttonPressed(){
        if isEditing{
            textView.endEditing(true)
        }else{
            isEditing = true
            setEditingMode(enabled: true)
        }
    }
    
    private func disableEditing(){
        currentText = textView.text
        setEditingMode(enabled: false)
        isEditing = false
        endEditing(true)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        disableEditing()
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
            textView.isEditable = false
            
            if let text = currentText, text.isEmpty, let _ = placeholderLabel.text{
                placeholderLabel.isHidden = false
            }else{
                placeholderLabel.isHidden = true
            }
        }else{
            textView.isEditable = true
            placeholderLabel.isHidden = true
            textView.becomeFirstResponder()
            toggleBorder(enabled: true)
        }
    }
    
    
    
    public func inizalize(inView view : UIView, withText text: String = "", placheolder: String? = nil){
        setUp(inView: view)
        
        if let p = placheolder, !p.isEmpty{
            placeholderLabel.text = p
        }
        currentText = text
        setEditingMode(enabled: false)
    }

}
