//
//  ContentView.swift
//  RightTyped-Keyboard
//
//  Created by Vitandrea Sorino on 26/05/23.
//

import UIKit

class ContentView: UIView {

    @IBOutlet var tableViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var categoryTableView: UITableView!
    public var footerView: FooterView?
    
    //MARK: Placeholder view
    var middleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.numberOfLines = 0;
        label.textAlignment = .center;
        label.font = UIFont(name: "Trakya Rounded 300 Light", size: 21)
        label.sizeToFit()
        label.text = "Ciao ciao"
        return label
    }()
    
    var placeholderView: UIView = {
        let cView: UIView = UIView(frame: .zero)
        cView.backgroundColor = .clear
        cView.translatesAutoresizingMaskIntoConstraints = false
        return cView
    }()
    
    
    public func configureView(withFooter: Bool){
        categoryTableView.register(UINib(nibName: "CategoryTableViewCell", bundle: nil), forCellReuseIdentifier: "categoryTableViewCellID")
        categoryTableView.alwaysBounceVertical = false
        
        if withFooter{
            footerView = FooterView()
            footerView!.frame = CGRect(x: 0, y: 0, width: 0, height: FOOTER_VIEW_HEIGHT)
            categoryTableView.tableFooterView = footerView!
        }
    }
    
    public func resetPlaceholder(){
        tableViewTopConstraint.isActive = true
        placeholderView.removeFromSuperview()
    }
    
    public func configurePlaceholderView(withContentViewHeight frameHeight: CGFloat, text: String){
        tableViewTopConstraint.isActive = false
        
        middleLabel.text = text
        placeholderView.addSubview(middleLabel)
        middleLabel.setFloodConstrait(in: placeholderView)
        
        self.addSubview(placeholderView)
        placeholderView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        placeholderView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        placeholderView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
        placeholderView.bottomAnchor.constraint(equalTo: categoryTableView.topAnchor).isActive = true
        placeholderView.heightAnchor.constraint(equalToConstant: frameHeight - FOOTER_VIEW_HEIGHT).isActive = true
    }
}
