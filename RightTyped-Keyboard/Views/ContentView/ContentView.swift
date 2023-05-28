//
//  ContentView.swift
//  RightTyped-Keyboard
//
//  Created by Vitandrea Sorino on 26/05/23.
//

import UIKit

class ContentView: UIView {

    @IBOutlet weak var categoryTableView: UITableView!
    public var footerView: FooterView?
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    public func configureView(withFooter: Bool){
        categoryTableView.register(UINib(nibName: "CategoryTableViewCell", bundle: nil), forCellReuseIdentifier: "categoryTableViewCellID")
        categoryTableView.alwaysBounceVertical = false
        
        if withFooter{
            footerView = FooterView()
            footerView!.frame = CGRect(x: 0, y: 0, width: 0, height: FOOTER_VIEW_HEIGHT)
            categoryTableView.tableFooterView = footerView!
        }
    }
}
