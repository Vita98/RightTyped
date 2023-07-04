//
//  ViewController.swift
//  RightTyped
//
//  Created by Vitandrea Sorino on 24/05/23.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    var selectedCategoryIndex : IndexPath?
    var selectedCategory : Category?
    
    @IBOutlet var containerView: CustomBaseView!
    @IBOutlet weak var tableShadowView: UIView!
    @IBOutlet weak var answersTableView: UITableView!
    
    fileprivate lazy var categoryFetchedResultsController: NSFetchedResultsController<Category> = Category.getFetchedResultControllerForAllCategory(delegate: self)
    var answers: [Answer]?
    var searchedAnswers: [Answer]?
    private var homeHeaderTableViewCell: HomeHeaderTableViewCell?
    private var answerHeaderView: AnswersHeaderView?
    private var addAnswerView: AddAnswerCustomView?
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addObservers()
        configureView()
        configureAnswersTableView()
        configureAddAnswerCustomView()
        
        //Performing the core data fetch
        do {
            try self.categoryFetchedResultsController.performFetch()
        } catch {
            let fetchError = error as NSError
            print("Unable to Perform Fetch Request")
            print("\(fetchError), \(fetchError.localizedDescription)")
        }
        
        //Close the addIconView every time another place on the screen is tapped
        containerView.touchInViewClosure = { [weak self] point in
            if let strongSelf = self, let addAnswerView = strongSelf.addAnswerView, addAnswerView.isOpened, !addAnswerView.frame.contains(point) {
                addAnswerView.setStatus(status: .closed, withAnimation: true)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    deinit{
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK: Configuration
    private func configureView(){
        self.view.backgroundColor = .backgroundColor
    }
    
    private func configureAnswersTableView(){
        answersTableView.register(UINib(nibName: "AnswerTableViewCell", bundle: nil), forCellReuseIdentifier: AnswerTableViewCell.reuseID)
        answersTableView.register(UINib(nibName: "HomeHeaderTableViewCell", bundle: nil), forCellReuseIdentifier: HomeHeaderTableViewCell.reuseID)
        answersTableView.dataSource = self
        answersTableView.delegate = self
        answersTableView.backgroundColor = .white
        answersTableView.clipsToBounds = true
        answersTableView.layer.cornerRadius = 45
        answersTableView.layer.maskedCorners = [.layerMaxXMinYCorner,.layerMinXMinYCorner]
        answersTableView.alwaysBounceVertical = false
        
        if #available(iOS 15.0, *) {
            answersTableView.sectionHeaderTopPadding = 0
        } else {
            answersTableView.contentInsetAdjustmentBehavior = .never
        }
        
        tableShadowView.dropShadow(shadowType: .contentView)
        tableShadowView.applyCustomRoundCorner()
    }
    
    private func configureAddAnswerCustomView(){
        addAnswerView = AddAnswerCustomView(inside: self.view)
        addAnswerView!.setCustomTapAction {[weak self] in
            guard let strongSelf = self else { return }
            let VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "newAnswerViewControllerID") as! NewAnswerViewController
            VC.delegate = self
            VC.isNewAnswer = true
            if strongSelf.selectedCategory != nil{ VC.setAnswerCategory(strongSelf.selectedCategory!) }
            strongSelf.view.endEditing(true)
            strongSelf.navigationController?.pushViewController(VC, animated: true)
        }
    }
    
    private func toggleComponent(enabled: Bool, withSearchBar: Bool = true){
        if let addAnswerView = addAnswerView{
            addAnswerView.isEnabled = enabled
        }
        if let homeHeaderTableViewCell = homeHeaderTableViewCell{
            homeHeaderTableViewCell.enableComponent(enabled: enabled, animated: true)
        }
        if let answerHeaderView = answerHeaderView, withSearchBar{
            answerHeaderView.setSearchBarStatus(enabled: enabled)
        }
    }
    
    //MARK: Keyboard events
    private func addObservers(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyBoardWillShow(notification: NSNotification){
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            answersTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight + 10, right: 0)
        }
    }
    
    @objc func keyBoardWillHide(notification: NSNotification){
        answersTableView.contentInset = .zero
    }
}

//MARK: Categories Collection view delegate and datasource
extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, NSFetchedResultsControllerDelegate, NewCategoryViewControllerDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let categories = categoryFetchedResultsController.fetchedObjects
        if categories == nil{
            collectionView.setEmptyMessage("Non hai nessuna categoria!")
            toggleComponent(enabled: false)
            return 0
        }else if categories!.isEmpty{
            collectionView.setEmptyMessage("Non hai nessuna categoria!")
            toggleComponent(enabled: false)
            return 0
        }
        
        collectionView.restore()
        toggleComponent(enabled: true, withSearchBar: false)
        return categories!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.reuseID, for: indexPath) as! CategoryCollectionViewCell
        let category = categoryFetchedResultsController.object(at: indexPath)
        cell.label.text = category.name
        cell.associatedCategory = category
        
        //Selection and deselection process
        if selectedCategoryIndex == nil{
            selectedCategoryIndex = indexPath
            selectedCategory = category
            if let ans = category.answers{
                answers = ans.allObjects as? [Answer]
                searchedAnswers = answers
                answersTableView.reloadData()
            }
            if let homeHeaderCell = answersTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? HomeHeaderTableViewCell{
                homeHeaderCell.selectedCategory = selectedCategory
            }
        }
        
        if indexPath == selectedCategoryIndex{
            cell.isSelected = true
            cell.setSelected(true)
        }else{
            cell.isSelected = false
            cell.setSelected(false)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //deselecting the previous
        guard let selectedCategoryIndex = selectedCategoryIndex else { return }
        let oldCell = collectionView.cellForItem(at: selectedCategoryIndex) as? CategoryCollectionViewCell
        oldCell?.setSelected(false, animated: true)
        let originIndex = selectedCategoryIndex.row
        
        //Selecting the current
        let cell = collectionView.cellForItem(at: indexPath) as! CategoryCollectionViewCell
        cell.setSelected(true, animated: true)
        self.selectedCategoryIndex = indexPath
        selectedCategory = categoryFetchedResultsController.object(at: indexPath)
        if let ans = selectedCategory?.answers{
            answers = ans.allObjects as? [Answer]
            searchedAnswers = answers
            reloadTableViewWithAnimation(originIndex: originIndex, destinationIndex: indexPath.row)
        }
        
        if let cell = answersTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? HomeHeaderTableViewCell{
            cell.selectedCategory = selectedCategory
        }
    }
    
    //MARK: NewCategoryViewController Delegate
    func newCategoryViewController(didInsert category: Category) {
        
        if let collectionView = homeHeaderTableViewCell?.categoryCollectionView {
            
            //Deselecting the previous, if present
            if  let indexPath = selectedCategoryIndex {
                guard let selectedCategoryIndex = selectedCategoryIndex else { return }
                let oldCell = collectionView.cellForItem(at: selectedCategoryIndex) as? CategoryCollectionViewCell
                oldCell?.setSelected(false, animated: true)
                let originIndex = selectedCategoryIndex.row
                
                //Inserting the new at the beginning
                let newIndexPath = IndexPath(row: 0, section: indexPath.section)
                homeHeaderTableViewCell?.categoryCollectionView.insertItems(at: [newIndexPath])
                homeHeaderTableViewCell?.categoryCollectionView.scrollToItem(at: newIndexPath, at: .centeredHorizontally, animated: true)
                
                if let cell = collectionView.cellForItem(at: newIndexPath) as? CategoryCollectionViewCell{
                    cell.setSelected(true, animated: true)
                }
                self.selectedCategoryIndex = newIndexPath
                
                selectedCategory = categoryFetchedResultsController.object(at: newIndexPath)
                if let ans = selectedCategory?.answers{
                    answers = ans.allObjects as? [Answer]
                    searchedAnswers = answers
                    reloadTableViewWithAnimation(originIndex: originIndex+1, destinationIndex: newIndexPath.row)
                }else{
                    answers = nil
                    searchedAnswers = nil
                    reloadTableViewWithAnimation(originIndex: originIndex, destinationIndex: newIndexPath.row)
                }
                
                if let cell = answersTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? HomeHeaderTableViewCell{
                    cell.selectedCategory = selectedCategory
                }
            }else{
                //Inserting the new at the beginning
                let newIndexPath = IndexPath(row: 0, section: 0)
                homeHeaderTableViewCell?.categoryCollectionView.insertItems(at: [newIndexPath])
                homeHeaderTableViewCell?.categoryCollectionView.scrollToItem(at: newIndexPath, at: .centeredHorizontally, animated: true)
                
                if let cell = collectionView.cellForItem(at: newIndexPath) as? CategoryCollectionViewCell{
                    cell.setSelected(true, animated: true)
                }else{
                    self.selectedCategoryIndex = newIndexPath
                }
                
                selectedCategory = categoryFetchedResultsController.object(at: newIndexPath)
                if let ans = selectedCategory?.answers{
                    answers = ans.allObjects as? [Answer]
                    searchedAnswers = answers
                    answersTableView.reloadSections(NSIndexSet(index: 1) as IndexSet, with: .fade)
                }else{
                    answers = nil
                    searchedAnswers = nil
                    answersTableView.reloadSections(NSIndexSet(index: 1) as IndexSet, with: .fade)
                }
                
                if let cell = answersTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? HomeHeaderTableViewCell{
                    cell.selectedCategory = selectedCategory
                }
            }
        }
    }
    
    func newCategoryViewController(didChange category: Category, at originIndexPath: IndexPath?) {
        if let indexPath = originIndexPath{
            UIView.animate(withDuration: 0.3) { [weak self] in
                self?.homeHeaderTableViewCell?.categoryCollectionView.reloadItems(at: [indexPath])
            }
            if let selectedCategoryIndex = selectedCategoryIndex, let originIndexPath = originIndexPath, selectedCategoryIndex == originIndexPath{
                homeHeaderTableViewCell?.setSwitch(enabled: category.enabled)
            }
        }else{
            answersTableView.reloadData()
        }
    }
}

//MARK: Drag and drop to change position of the categories
extension ViewController: UICollectionViewDragDelegate, UICollectionViewDropDelegate{
    //MARK: UICollectionViewDragDelegate
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let categoryItem = categoryFetchedResultsController.object(at: indexPath)
        let itemProvider = NSItemProvider(object: "\(categoryItem.id.hashValue)" as NSString)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        dragItem.localObject = categoryItem
        return [dragItem]
    }
    
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        return UICollectionViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        guard let destinationIndexPath = coordinator.destinationIndexPath, coordinator.proposal.operation == .move else { return }
        
        //Update the collection view
        if let item = coordinator.items.first, let sourceIndexPath = item.sourceIndexPath{
            
            let originCategory = categoryFetchedResultsController.object(at: sourceIndexPath)
            let destinationCategory = categoryFetchedResultsController.object(at: destinationIndexPath)
            
            //Perform the swap on core data
            if moveOnCoreData(collectionView, objToMove: (originCategory, sourceIndexPath), destinationObj: (destinationCategory, destinationIndexPath)){
                collectionView.performBatchUpdates( {
                    collectionView.deleteItems(at: [sourceIndexPath])
                    collectionView.insertItems(at: [destinationIndexPath])
                    updateSelectedCategoryAfterDragAndDrop(sourceIndexPath: sourceIndexPath, destinationIndexPath: destinationIndexPath)
                })
                coordinator.drop(item.dragItem, toItemAt: destinationIndexPath)
            }
        }
    }
    
    private func updateSelectedCategoryAfterDragAndDrop(sourceIndexPath: IndexPath, destinationIndexPath: IndexPath){
        if sourceIndexPath == selectedCategoryIndex{
            selectedCategoryIndex = destinationIndexPath
        }else if destinationIndexPath == selectedCategoryIndex{
            //have to shift the selected indexpath by one left or right
            if sourceIndexPath.row > destinationIndexPath.row{
                //swiping an element to its left
                selectedCategoryIndex = IndexPath(row: destinationIndexPath.row + 1, section: destinationIndexPath.section)
            }else if sourceIndexPath.row < destinationIndexPath.row{
                selectedCategoryIndex = IndexPath(row: destinationIndexPath.row - 1, section: destinationIndexPath.section)
            }
        }else{
            //the selectedCategory is not neither the source nor the destination
            if let selectedCategoryIndex = self.selectedCategoryIndex{
                if selectedCategoryIndex.row > destinationIndexPath.row && selectedCategoryIndex.row < sourceIndexPath.row{
                    self.selectedCategoryIndex = IndexPath(row: selectedCategoryIndex.row + 1, section: selectedCategoryIndex.section)
                }else if selectedCategoryIndex.row < destinationIndexPath.row && selectedCategoryIndex.row > sourceIndexPath.row {
                    self.selectedCategoryIndex = IndexPath(row: selectedCategoryIndex.row - 1, section: selectedCategoryIndex.section)
                }
            }
        }
    }
    
    private func moveOnCoreData(_ collectionView: UICollectionView, objToMove: (Category, IndexPath), destinationObj: (Category, IndexPath)) -> Bool {
        if destinationObj.1.row == 0{
            //Check if the move is on the left bound - index.row == 0
            if ceil(destinationObj.0.order) == destinationObj.0.order{
                objToMove.0.order = destinationObj.0.order + 1
            }else{
                objToMove.0.order = ceil(destinationObj.0.order)
            }
        }else if let count = categoryFetchedResultsController.fetchedObjects?.count, destinationObj.1.row == count-1{
            //Check if the move is on the right bound - index.row == number of abject minus one
            if floor(destinationObj.0.order) == destinationObj.0.order{
                objToMove.0.order = destinationObj.0.order - 1
            }else{
                objToMove.0.order = floor(destinationObj.0.order)
            }
        }else{
            //middle move
            var newOrder: Double = 0.0
            if objToMove.1.row < destinationObj.1.row{
                let leftCat = categoryFetchedResultsController.object(at: IndexPath(row: destinationObj.1.row + 1, section: destinationObj.1.section))
                let rightCat = categoryFetchedResultsController.object(at: destinationObj.1)
                newOrder = (leftCat.order + rightCat.order) / 2
            }else{
                let leftCat = categoryFetchedResultsController.object(at: IndexPath(row: destinationObj.1.row - 1, section: destinationObj.1.section))
                let rightCat = categoryFetchedResultsController.object(at: destinationObj.1)
                newOrder = (leftCat.order + rightCat.order) / 2
            }
            objToMove.0.order = newOrder
        }
        
        return DataModelManagerPersistentContainer.shared.saveContextWithCheck()
    }
    
    //MARK: Method to show the shadows even during the drag and dropp process
    func collectionView(_ collectionView: UICollectionView, dropPreviewParametersForItemAt indexPath: IndexPath) -> UIDragPreviewParameters? {
        let dragPrevParam: UIDragPreviewParameters = UIDragPreviewParameters()
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.reuseID, for: indexPath) as? CategoryCollectionViewCell else { return nil }
        dragPrevParam.backgroundColor = .black.withAlphaComponent(0.3)
        dragPrevParam.visiblePath = UIBezierPath(roundedRect: CGRect(x: -0.5, y: -0.5, width: cell.frame.width+3, height: cell.frame.height+2), cornerRadius: 15)
        return dragPrevParam
    }
    
    func collectionView(_ collectionView: UICollectionView, dragPreviewParametersForItemAt indexPath: IndexPath) -> UIDragPreviewParameters? {
        let dragPrevParam: UIDragPreviewParameters = UIDragPreviewParameters()
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.reuseID, for: indexPath) as? CategoryCollectionViewCell else { return nil }
        dragPrevParam.backgroundColor = .black.withAlphaComponent(0.3)
        dragPrevParam.visiblePath = UIBezierPath(roundedRect: CGRect(x: -0.5, y: -0.5, width: cell.frame.width+3, height: cell.frame.height+2), cornerRadius: 15)
        return dragPrevParam
    }
}


//MARK: Answers table view delegate and datasource
extension ViewController: UITableViewDelegate, UITableViewDataSource, NewAnswerViewControllerDelegate, HomeHeaderTableViewCellDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 1
        }else{
            if let answers = answers{
                answerHeaderView?.setSearchBarStatus(enabled: !answers.isEmpty)
            }
            return searchedAnswers != nil ? searchedAnswers!.count : 0
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 { return nil }
        
        guard let header : AnswersHeaderView = AnswersHeaderView.instanceFromNib(withNibName: AnswersHeaderView.NIB_NAME) else { return nil }
        header.configureCell()
        header.searchBar.delegate = self
        header.searchBar.searchTextField.delegate = self
        header.setSearchBarStatus(enabled: answers != nil && answers!.count > 0)
        answerHeaderView = header
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0{
            return 0
        }else{
            return SEARCH_BAR_SECTION_HEADER_HEIGHT
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: HomeHeaderTableViewCell.reuseID, for: indexPath) as! HomeHeaderTableViewCell
            cell.categoryCollectionView.dataSource = self
            cell.categoryCollectionView.delegate = self
            cell.categoryCollectionView.dragDelegate = self
            cell.categoryCollectionView.dropDelegate = self
            cell.delegate = self
            homeHeaderTableViewCell = cell
            
            if let cat = selectedCategory{
                cell.selectedCategory = cat
            }
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: AnswerTableViewCell.reuseID, for: indexPath) as! AnswerTableViewCell
        guard let searchedAnswers = searchedAnswers else { return cell }
        let answer = searchedAnswers[indexPath.row]
        cell.answerLabel.text = answer.title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let searchedAnswers = searchedAnswers, indexPath.section > 0 else { return }
        
        let VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "newAnswerViewControllerID") as! NewAnswerViewController
        VC.setAnswer(searchedAnswers[indexPath.row])
        VC.delegate = self
        VC.originTableViewIndexPath = indexPath
        self.view.endEditing(true)
        self.navigationController?.pushViewController(VC, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    private func reloadTableViewWithAnimation(originIndex : Int, destinationIndex: Int){
        guard originIndex != destinationIndex else { return }
        answersTableView.reloadSections(NSIndexSet(index: 1) as IndexSet, with: originIndex>destinationIndex ? .right : .left)
    }
    
    //MARK: newAnwerViewController delegate
    func newAnswerViewController(didChange answer: Answer, at originIndexPath: IndexPath?) {
        if let indexPath = originIndexPath{
            answersTableView.reloadRows(at: [indexPath], with: .fade)
        }else{
            answersTableView.reloadData()
        }
    }
    
    func newAnswerViewController(didDelete answer: Answer, at originIndexPath: IndexPath?) {
        if let indexPath = originIndexPath{
            searchedAnswers?.remove(at: indexPath.row)
            if let answers = answers, let index = answers.firstIndex(of: answer){
                self.answers!.remove(at: index)
                if let answerHeaderView = answerHeaderView {
                    answerHeaderView.setSearchBarStatus(enabled: self.answers!.count > 0)
                }
            }
            answersTableView.deleteRows(at: [indexPath], with: .left)
            
        }else{
            answersTableView.reloadData()
        }
    }
    
    func newAnswerViewController(didInsert answer: Answer) {
        answers?.append(answer)
        if let answerHeaderView = answerHeaderView{
            if let text = answerHeaderView.searchBar.text, !text.isEmpty{
                if answer.title.lowercased().contains(text.lowercased()) || answer.descr.lowercased().contains(text.lowercased()){
                    searchedAnswers?.append(answer)
                    if searchedAnswers != nil { answersTableView.insertRows(at: [IndexPath(row: searchedAnswers!.count-1, section: 1)], with: .automatic) }
                }
                return
            }
        }
        searchedAnswers = answers
        if answers != nil { answersTableView.insertRows(at: [IndexPath(row: answers!.count-1, section: 1)], with: .automatic) }
        if let answerHeaderView = answerHeaderView {
            answerHeaderView.setSearchBarStatus(enabled: self.answers!.count > 0)
        }
    }
    
    //MARK: HomeHeaderTableViewCell delegate
    func homeHeaderTableViewCellDidPressed(event: HomeHeaderTableViewCell.PressionEvent) {
        switch event{
        case .AddNew:
            let VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "newCategoryViewController") as! NewCategoryViewController
            VC.modalTransitionStyle = .crossDissolve
            VC.modalPresentationStyle = .overFullScreen
            VC.delegate = self
            self.view.endEditing(true)
            self.present(VC, animated: true)
        case .Change:
            let VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "newCategoryViewController") as! NewCategoryViewController
            VC.modalTransitionStyle = .crossDissolve
            VC.modalPresentationStyle = .overFullScreen
            VC.setCategory(selectedCategory, indexPath: selectedCategoryIndex)
            VC.editMode = true
            VC.delegate = self
            self.view.endEditing(true)
            self.present(VC, animated: true)
        case .Delete:
            let alert = UIAlertController(title: "Sei sicuro?", message: "Sei sicuro di voler cancellare questa categoria?\nTutte le domande associate verranno anch'esse cancellate", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "No", style: .cancel))
            alert.addAction(UIAlertAction(title: "Si", style: .destructive, handler: { alertAction in
                if let selectedCategory = self.selectedCategory{
                    DataModelManagerPersistentContainer.shared.context.delete(selectedCategory)
                    DataModelManagerPersistentContainer.shared.saveContext()
                }
            }))
            
            self.present(alert, animated: true)
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        if type == .delete, let indexPath = indexPath, let cat = categoryFetchedResultsController.fetchedObjects?.count{
            let nextCellIndex = indexPath.nearest(withLeftBound: cat)
            
            if let nextCellIndex = nextCellIndex{
                
                if nextCellIndex.row > indexPath.row{
                    let f = IndexPath(row: nextCellIndex.row-1, section: indexPath.section)
                    selectedCategoryIndex = f
                }else{
                    selectedCategoryIndex = nextCellIndex
                }
                
                if let nextCell = homeHeaderTableViewCell?.categoryCollectionView.cellForItem(at: nextCellIndex) as? CategoryCollectionViewCell{
                    nextCell.setSelected(true)
                    self.selectedCategory = nextCell.associatedCategory
                }else if let index = selectedCategoryIndex{
                    self.selectedCategory = categoryFetchedResultsController.object(at: index)
                }
                
                if let snw = self.selectedCategory?.answers, let answers = snw.allObjects as? [Answer]{
                    self.answers = answers
                    self.searchedAnswers = answers
                }
                reloadTableViewWithAnimation(originIndex: indexPath.row, destinationIndex: nextCellIndex.row)
                homeHeaderTableViewCell?.categoryCollectionView.deleteItems(at: [indexPath])
                answerHeaderView?.setSearchBarStatus(enabled: answers != nil && answers!.count > 0)
            }else{
                homeHeaderTableViewCell?.categoryCollectionView.deleteItems(at: [indexPath])
                self.selectedCategory = nil
                self.selectedCategoryIndex = nil
                self.answers = nil
                self.searchedAnswers = nil
                answersTableView.reloadSections(IndexSet(integer: 1), with: .fade)
            }
        }
    }
}

//MARK: Search bar delegate
extension ViewController: UISearchBarDelegate, UISearchTextFieldDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchedAnswers = searchText.isEmpty ? answers : answers?.filter({ answer in
            return answer.title.lowercased().contains(searchText.lowercased()) || answer.descr.lowercased().contains(searchText.lowercased())
        })
        answersTableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchedAnswers = answers
        searchBar.endEditing(true)
        answersTableView.reloadData()
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
}



