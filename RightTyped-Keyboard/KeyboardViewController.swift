//
//  KeyboardViewController.swift
//  RightTyped-Keyboard
//
//  Created by Vitandrea Sorino on 24/05/23.
//

import UIKit

class KeyboardViewController: UIInputViewController {

    @IBOutlet var nextKeyboardButton: UIButton!
    var contentView : ContentView!
    var contentViewHightConstraint: NSLayoutConstraint?
    
    var keyboardAppearance : UIKeyboardAppearance?
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        
        // Add custom view sizing constraints here
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setContentView()
        
        //Setting the background color
        self.view.backgroundColor = .none
    }
    
    
   
    
    private func setContentView(){
        guard let cV : ContentView = ContentView.instanceFromNib(withNibName: "ContentView") else { return }
        contentView = cV
        contentView.configureView(withFooter: self.needsInputModeSwitchKey)
        
        self.view.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        contentView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        
        setInterfaceHeight()
        setCategoryTableView()
    }
    
    private func setCategoryTableView(){
        contentView.categoryTableView.dataSource = self
        contentView.categoryTableView.delegate = self
        
        if self.needsInputModeSwitchKey{
            contentView.footerView?.globeButton.addTarget(self, action: #selector(handleInputModeList(from:with:)), for: .allTouchEvents)
        }
    }
    
    private func setInterfaceHeight(fromWillTransition : Bool = false){
        //Setting the height of the keyboard based on the number of category
        
        //Invert the with and height when the user interface rotate
        var size = CGSize()
        if fromWillTransition{
            size.width = UIScreen.main.bounds.size.height
            size.height = UIScreen.main.bounds.size.width
        }else{
            size = UIScreen.main.bounds.size
        }
        
        if let constraint = contentViewHightConstraint{
            contentView.removeConstraint(constraint)
        }
        
        let maxHeight = CATEGORY_TABLE_VIEW_CELL_HEIGHT * CGFloat(NUMBER_OF_CATEGORY) + (self.needsInputModeSwitchKey ? FOOTER_VIEW_HEIGHT : 0)
        if maxHeight <= size.height / 2 {
            contentViewHightConstraint = contentView.heightAnchor.constraint(equalToConstant: maxHeight)
        }else{
            contentViewHightConstraint = contentView.heightAnchor.constraint(equalToConstant: size.height / 2)
        }
        contentViewHightConstraint?.isActive = true
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    
    override func textWillChange(_ textInput: UITextInput?) {
        // The app is about to change the document's contents. Perform any preparation here.
    }
    
    override func textDidChange(_ textInput: UITextInput?) {
        // The app has just changed the document's contents, the document context has been updated.
        let proxy = self.textDocumentProxy
        if let appearence = proxy.keyboardAppearance {
            keyboardAppearance = appearence
            contentView.footerView?.textDidChange(appearance: appearence)
            contentView.categoryTableView.reloadData()
        }
       
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        setInterfaceHeight(fromWillTransition: true)
    }

}

extension KeyboardViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return NUMBER_OF_CATEGORY
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryTableViewCellID", for: indexPath) as! CategoryTableViewCell
        cell.configureCell()
        if let appearance = keyboardAppearance{
            cell.textDidChange(appearance: appearance)
        }
        return cell
    }
}
