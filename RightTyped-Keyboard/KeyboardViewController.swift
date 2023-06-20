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
    
    fileprivate lazy var categoryFetchedResultsController: NSFetchedResultsController<Category> = Category.getFetchedResultControllerForCategory(delegate: self)
    private var actualCategoryCount: Int = 0
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        
        // Add custom view sizing constraints here
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setContentView()
        
        //Setting the background color
        self.view.backgroundColor = .none
        
        //Extecute the core data fetch
        do {
            try DataModelManagerPersistentContainer.shared.context.setQueryGenerationFrom(.current)
            DataModelManagerPersistentContainer.shared.context.refreshAllObjects()
            try self.categoryFetchedResultsController.performFetch()
        } catch {
            let fetchError = error as NSError
            print("Unable to Perform Fetch Request")
            print("\(fetchError), \(fetchError.localizedDescription)")
        }
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
        
        actualCategoryCount = Category.getCategoryCount()
        let maxHeight = CATEGORY_TABLE_VIEW_CELL_HEIGHT * CGFloat(actualCategoryCount) + (self.needsInputModeSwitchKey ? FOOTER_VIEW_HEIGHT : 0)
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

extension KeyboardViewController: UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let categories = categoryFetchedResultsController.fetchedObjects{
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryTableViewCellID", for: indexPath) as! CategoryTableViewCell
        let category = categoryFetchedResultsController.object(at: indexPath)
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
