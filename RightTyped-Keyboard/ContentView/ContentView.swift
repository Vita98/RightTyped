//
//  ContentView.swift
//  RightTyped-Keyboard
//
//  Created by Vitandrea Sorino on 26/05/23.
//

import UIKit

class ContentView: UIView {

    @IBOutlet weak var categoryTableView: UITableView!
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    public func configureView(){
        categoryTableView.register(UINib(nibName: "CategoryTableViewCell", bundle: nil), forCellReuseIdentifier: "categoryTableViewCellID")
        categoryTableView.alwaysBounceVertical = false
    }
    
    class func instanceFromNib() -> ContentView? {
        return UINib(nibName: "ContentView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as? ContentView
    }

}
