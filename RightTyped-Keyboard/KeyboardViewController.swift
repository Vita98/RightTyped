//
//  KeyboardViewController.swift
//  RightTyped-Keyboard
//
//  Created by Vitandrea Sorino on 24/05/23.
//

import UIKit
import CoreData

class KeyboardViewController: UIInputViewController {

    @IBOutlet var nextKeyboardButton: UIButton!
    var contentView : ContentView!
    var contentViewHightConstraint: NSLayoutConstraint?
    var popoverView: PopoverView?
    
    var keyboardAppearance : UIKeyboardAppearance?
    var categories: [Category]?
    
    var lastTextInjected: String?
    
    private var actualCategoryCount: Int = 0
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setContentView()
        
        //Setting the background color
        self.view.backgroundColor = .none
        
        //Extecute the core data fetch
        if !UserDefaultManager.shared.isFirstBootForExtension(){
            categories = Category.getCategory(withAtLeastOneEnabledAnswer: true)
        }
    }
    
    //MARK: Configuration
    private func setContentView(){
        guard let cV : ContentView = ContentView.instanceFromNib(withNibName: "ContentView") else { return }
        contentView = cV
        contentView.configureView(withGlobe: self.needsInputModeSwitchKey)
        contentView.footerView?.undoButton.addTarget(self, action: #selector(undoBottonPressed), for: .touchUpInside)
        
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
        
        if UserDefaultManager.shared.isFirstBootForExtension(){
            //set the maximum height to fit the view with the error message
            contentViewHightConstraint = contentView.heightAnchor.constraint(equalToConstant: size.height / 2)
            contentView.configurePlaceholderView(withContentViewHeight: size.height / 2, text: "Apri l'app prima di iniziare ad usare la tastiera!")
        }else{
            DataModelManagerPersistentContainer.tryResettingContainer()
            contentView.resetPlaceholder()
            actualCategoryCount = Category.getCategoryCount(withAtLeastOneEnabledAnswer: true)
            print("CAT COUNT: \(actualCategoryCount)")
            if actualCategoryCount > 0{
                let maxHeight = CATEGORY_TABLE_VIEW_CELL_HEIGHT * CGFloat(actualCategoryCount) + (self.needsInputModeSwitchKey ? FOOTER_VIEW_HEIGHT : 0)
                if maxHeight <= size.height / 2 {
                    contentViewHightConstraint = contentView.heightAnchor.constraint(equalToConstant: maxHeight)
                }else{
                    contentViewHightConstraint = contentView.heightAnchor.constraint(equalToConstant: size.height / 2)
                }
            }else{
                //Show the view telling that there are not categories available
                contentViewHightConstraint = contentView.heightAnchor.constraint(equalToConstant: size.height / 2)
                contentView.configurePlaceholderView(withContentViewHeight: size.height / 2, text: "Non ci sono categorie abilitate!\nEntra nell'app e abilita quelle che più fanno per te o creane delle nuove!")
            }
        }
        contentViewHightConstraint?.isActive = true
    }
    
    //MARK: Event
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
    
    @objc private func undoBottonPressed(){
        guard let _ = self.textDocumentProxy.documentContextBeforeInput, let lastTextInjected = lastTextInjected else { return }
        for _ in lastTextInjected{
            self.textDocumentProxy.deleteBackward()
        }
        contentView.footerView?.setUndoButton(enabled: false)
        self.lastTextInjected = nil
    }
}

extension KeyboardViewController: UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let categories = categories{
            let catCount = categories.count
            if catCount != actualCategoryCount{
                actualCategoryCount = catCount
                setInterfaceHeight()
            }
            return catCount
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let category = categories?[indexPath.row] else { return UITableViewCell() }
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryTableViewCellID", for: indexPath) as! CategoryTableViewCell
        cell.configureCell()
        cell.cellDelegate = self
        cell.setCategory(category)
        
        if let appearance = keyboardAppearance{
            cell.textDidChange(appearance: appearance)
        }
        return cell
    }
}

extension KeyboardViewController: AnswerCollectionViewCellDelegate{
    func answerCollectionViewCellTouchUpInside(withAnswer answer: Answer) {
        print("Touch up inside")
        self.textDocumentProxy.insertText(answer.descr)
        lastTextInjected = answer.descr
        contentView.footerView?.setUndoButton(enabled: true)
    }
    
    func answerCollectionViewCellLongPress(withAnswer answer: Answer, state: UIGestureRecognizer.State) {
        switch state{
        case .began:
            let ppV = PopoverView(frame: self.view.frame, keyboardAppearance: keyboardAppearance)
            ppV.setText(answer.descr)
            ppV.setIn(self.view)
            ppV.show(hideView: contentView)
            popoverView = ppV
        case .ended, .cancelled, .failed:
            if let ppV = popoverView{
                ppV.removeFromSuperviewWithAnimation()
            }
        default:
            break
        }
    }
}
