//
//  ViewController.swift
//  RightTyped
//
//  Created by Vitandrea Sorino on 24/05/23.
//

import UIKit
import CoreData

class ViewController: UIViewController, SelectCategoriesViewControllerDelegate{
    
    var selectedCategoryIndex : IndexPath?
    var selectedCategory : Category?
    var showTutorial = false
    var showWelcome = false
    
    @IBOutlet var containerView: CustomBaseView!
    @IBOutlet weak var tableShadowView: UIView!
    @IBOutlet weak var answersTableView: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    
    fileprivate lazy var categoryFetchedResultsController: NSFetchedResultsController<Category> = Category.getFetchedResultControllerForAllCategory(delegate: self)
    var answers: [Answer]? {
        didSet{
            guard let answers = answers else { return }
            self.answers = answers.sorted(by: {$0.order > $1.order})
            self.searchedAnswers = self.answers
            answersTableView.dragInteractionEnabled = answers.count > 1
        }
    }
    var searchedAnswers: [Answer]?
    private var homeHeaderTableViewCell: HomeHeaderTableViewCell?
    private var answerHeaderView: AnswersHeaderView?
    private var addAnswerView: AddAnswerCustomView?
    private var tableViewEmptyMessageHeight: Double = 0
    private var loader: LoadingViewController?
    private var loaderTimer: Timer?
    private var first = true
    private var changesMade = false
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.set(text: AppString.ViewController.title, size: 18)
        
        if showWelcome, let rNC = UINavigationController.instantiateNavController(withRoot: WelcomeViewController.self){
            self.present(rNC.navController, animated: true)
        }
        
        if showTutorial, let rNC = UINavigationController.instantiateNavController(withRoot: EnableKeyboardViewController.self){
            self.present(rNC.navController, animated: true)
        }
        
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
        resetBackButtonText()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addObservers()
        navigationController?.setNavigationBarHidden(true, animated: animated)
        updateAddCatIconVisibility()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        homeHeaderTableViewCell?.categoryCollectionView.reloadData()
        answersTableView.reloadData()
        
        if UserDefaultManager.shared.hasProPlanJustBeenDisabled(){
            delayedExecution()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    deinit{
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK: Observers
    private func addObservers(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(proPlanUpdate), name: Notification.Name(UserDefaultManager.PRO_PLAN_ENABLED_KEY), object: nil)
    }
    
    //MARK: Alerts
    private func showChooseCategories(){
        let alert : GenericResultViewController = UIStoryboard.main().instantiate()
        alert.configure(image: UIImage(named: "warningIcon"), title: AppString.Premium.Popup.ProNotRenewed.title, description: AppString.Premium.Popup.ProNotRenewed.description)
        alert.addButton(withText: AppString.SettingsModel.premiumText){[weak self] in
            alert.dismiss(animated: true)
            let VC: PremiumViewController = UIStoryboard.premium().instantiate()
            self?.navigationController?.pushViewController(VC, animated: true)
        }
        alert.addButton(withText: AppString.Premium.Popup.ProNotRenewed.selectCategoriesButton){[weak self] in
            alert.dismiss(animated: true)
            let VC: SelectCategoriesViewController = UIStoryboard.premium().instantiate()
            VC.delegate = self
            self?.view.endEditing(true)
            self?.navigationController?.pushViewController(VC, animated: true)
        }
        alert.modalTransitionStyle = .crossDissolve
        alert.modalPresentationStyle = .overFullScreen
        self.present(alert, animated: true)
    }
    
    private func showProRestored(){
        let alert : GenericResultViewController = UIStoryboard.main().instantiate()
        let expDate = ReceiptValidatorHelper.shared.getProPlanExpirationDate() ?? Date()
        alert.configure(image: UIImage(named: "tickIcon"), title: AppString.Premium.Popup.SuccessProRestoration.title, description: String(format: AppString.Premium.Popup.SuccessProRestoration.description, DateFormatter.getFormatted(expDate)))
        alert.addButton(withText: AppString.General.close){
            alert.dismiss(animated: true)
        }
        alert.modalTransitionStyle = .crossDissolve
        alert.modalPresentationStyle = .overFullScreen
        self.present(alert, animated: true)
    }
    
    private func showProDisabled(){
        let alert : GenericResultViewController = UIStoryboard.main().instantiate()
        alert.configure(image: UIImage(named: "warningIcon"), title: AppString.Premium.Popup.ProNotRenewedNoCatSelection.title, description: String(format: AppString.Premium.Popup.ProNotRenewedNoCatSelection.description, MAXIMUM_ANSWERS_FOR_CATEGORIES))
        alert.addButton(withText: AppString.SettingsModel.premiumText){[weak self] in
            alert.dismiss(animated: true)
            let VC: PremiumViewController = UIStoryboard.premium().instantiate()
            self?.navigationController?.pushViewController(VC, animated: true)
        }
        alert.addButton(withText: AppString.Premium.Popup.ProNotRenewedNoCatSelection.notInterested){
            UserDefaultManager.shared.setBoolValue(key: UserDefaultManager.PRO_PLAN_HAS_JUST_BEEN_DISABLED, enabled: false)
            UserDefaultManager.shared.setProPlanExpirationDate(nil)
            alert.dismiss(animated: true)
        }
        alert.modalTransitionStyle = .crossDissolve
        alert.modalPresentationStyle = .overFullScreen
        self.present(alert, animated: true)
    }
    
    private func showDisabledCategory(){
        let alert : GenericResultViewController = UIStoryboard.main().instantiate()
        alert.configure(image: UIImage(named: "warningIcon"), title: AppString.Premium.Popup.CategoryDisabled.title, description: AppString.Premium.Popup.CategoryDisabled.description)
        alert.addButton(withText: AppString.SettingsModel.premiumText){[weak self] in
            alert.dismiss(animated: true)
            let VC: PremiumViewController = UIStoryboard.premium().instantiate()
            self?.navigationController?.pushViewController(VC, animated: true)
        }
        alert.addButton(withText: AppString.Premium.Popup.ProNotRenewedNoCatSelection.notInterested){ alert.dismiss(animated: true) }
        alert.modalTransitionStyle = .crossDissolve
        alert.modalPresentationStyle = .overFullScreen
        self.present(alert, animated: true)
    }
    
    private func showDisabledAnswer(){
        let alert : GenericResultViewController = UIStoryboard.main().instantiate()
        alert.configure(image: UIImage(named: "warningIcon"), title: AppString.Premium.Popup.AnswerDisabled.title, description: AppString.Premium.Popup.AnswerDisabled.description)
        alert.addButton(withText: AppString.SettingsModel.premiumText){[weak self] in
            alert.dismiss(animated: true)
            let VC: PremiumViewController = UIStoryboard.premium().instantiate()
            self?.navigationController?.pushViewController(VC, animated: true)
        }
        alert.addButton(withText: AppString.Premium.Popup.ProNotRenewedNoCatSelection.notInterested){ alert.dismiss(animated: true) }
        alert.modalTransitionStyle = .crossDissolve
        alert.modalPresentationStyle = .overFullScreen
        self.present(alert, animated: true)
    }
    
    //MARK: SelectCategoriesViewControllerDelegate
    func selectCategoriesViewControllerChangesMade() {
        changesMade = true
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
        answersTableView.dragDelegate = self
        answersTableView.dropDelegate = self
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
            
            guard let strongSelf = self, let selectedCategory = self?.selectedCategory, let answers = selectedCategory.answers?.allObjects as? [Answer] else { return }
            let answersCount = answers.filter({!$0.forceDisabled}).count
            if UserDefaultManager.shared.getProPlanStatus() || answersCount < Int(selectedCategory.maxAnswers){
                let VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "newAnswerViewControllerID") as! NewAnswerViewController
                VC.delegate = self
                VC.isNewAnswer = true
                VC.setAnswerCategory(selectedCategory)
                strongSelf.view.endEditing(true)
                strongSelf.navigationController?.pushViewController(VC, animated: true)
            }else{
                let alert = UIAlertController(title: AppString.Alerts.noMoreAnswersAvailable, message: String(format: AppString.Alerts.noMoreAnswersAvailableDescription, Int(selectedCategory.maxAnswers)) , preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: AppString.Alerts.goToPremiumSection, style: .default, handler: {alertAction in
                    let VC: PremiumViewController = UIStoryboard.premium().instantiate()
                    strongSelf.navigationController?.pushViewController(VC, animated: true)
                }))
                alert.addAction(UIAlertAction(title: AppString.Alerts.no, style: .cancel))
                strongSelf.present(alert, animated: true)
            }
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
            answerHeaderView.setSearchBarStatus(enabled: self.answers?.count ?? 0 > 0)
        }
    }
    
    private func toggleLoadingViewController(show: Bool = false, completion: (() -> Void)? = nil){
        if !show && loader != nil{
            loader?.dismiss(animated: true){
                completion?()
                self.loader = nil
            }
        }else{
            loader = LoadingViewController()
            loader?.show(in: self)
        }
    }
    
    private func updateAddCatIconVisibility(){
        //Updating the add category icon
        if let count = categoryFetchedResultsController.fetchedObjects?.filter({!$0.forceDisabled}).count{
            if UserDefaultManager.shared.getProPlanStatus(){
                homeHeaderTableViewCell?.enableAddButton(true, animated: true)
            }else{
                homeHeaderTableViewCell?.enableAddButton(count < Product.getMaximumCategoriesCount(), animated: true)
            }
            homeHeaderTableViewCell?.updateCatCount()
        }
    }
    
    //MARK: Pro plan update callback
    private func delayedExecution(){
        if first{
            toggleLoadingViewController(show: true)
            first = false
            loaderTimer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: false, block: {[weak self] timer in
                guard let strongSelf = self else { return }
                strongSelf.toggleLoadingViewController(){
                    if !UserDefaultManager.shared.getProPlanStatus(){
                        if Category.needToChooseCategories(){ strongSelf.showChooseCategories() }
                        else { strongSelf.showProDisabled() }
                    }
                }
                timer.invalidate()
                strongSelf.loaderTimer = nil
            })
        }else{
            if !UserDefaultManager.shared.getProPlanStatus(){
                if Category.needToChooseCategories(){ showChooseCategories() }
                else { showProDisabled() }
            }
            loaderTimer = nil
        }
    }
    
    @objc private func proPlanUpdate(){
        if loaderTimer != nil{
            self.loaderTimer!.invalidate()
            self.loaderTimer = nil
        }
        
        if loader == nil {
            if !UserDefaultManager.shared.getProPlanStatus(){
                if Category.needToChooseCategories(){ self.showChooseCategories() }
                else { self.showProDisabled() }
            }else{
                self.showProRestored()
                self.updateAddCatIconVisibility()
            }
        }else{
            toggleLoadingViewController(){
                if !UserDefaultManager.shared.getProPlanStatus(){
                    if Category.needToChooseCategories(){ self.showChooseCategories() }
                    else { self.showProDisabled() }
                }else{
                    self.showProRestored()
                    self.updateAddCatIconVisibility()
                }
            }
        }
    }
    
    //MARK: Keyboard events
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
    
    //MARK: Generic events
    @IBAction func settingsTouchUpInside(_ sender: Any) {
        let VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "settingsViewControllerID") as! SettingsViewController
        self.view.endEditing(true)
        self.navigationController?.pushViewController(VC, animated: true)
    }
}

//MARK: Categories Collection view delegate and datasource
extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, NSFetchedResultsControllerDelegate, NewCategoryViewControllerDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let categories = categoryFetchedResultsController.fetchedObjects
        let filteredCat = categoryFetchedResultsController.fetchedObjects?.filter({!$0.forceDisabled})
        guard let cat = categories, !cat.isEmpty else {
            collectionView.setEmptyMessage(AppString.ViewController.emptyCategories)
            answersTableView.setEmptyMessage(AppString.ViewController.noCategoryUsable, height: tableViewEmptyMessageHeight)
            toggleComponent(enabled: false)
            homeHeaderTableViewCell?.enableAddButton(true)
            return 0
        }
        
        if let filteredCat = filteredCat{
            if filteredCat.isEmpty{
                toggleComponent(enabled: false)
                homeHeaderTableViewCell?.enableAddButton(true)
                selectedCategoryIndex = nil
                answersTableView.setEmptyMessage(AppString.ViewController.noCategoryUsable, height: tableViewEmptyMessageHeight)
                return categories!.count
            } else if filteredCat.count < Product.getMaximumCategoriesCount() || UserDefaultManager.shared.getProPlanStatus(){
                //enable the add button
                homeHeaderTableViewCell?.enableAddButton(true)
                toggleComponent(enabled: true)
            } else {
                homeHeaderTableViewCell?.enableAddButton(false)
            }
        }else{
            //disable the add button
            homeHeaderTableViewCell?.enableAddButton(false)
        }
        
        collectionView.restoreEmptyMessage()
        return categories!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.reuseID, for: indexPath) as! CategoryCollectionViewCell
        let category = categoryFetchedResultsController.object(at: indexPath)
        cell.label.text = category.name
        cell.associatedCategory = category
        
        //Selection and deselection process
        if (selectedCategoryIndex == nil || changesMade) && !category.forceDisabled{
            changesMade = false
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
        guard !categoryFetchedResultsController.object(at: indexPath).forceDisabled else { showDisabledCategory(); return }
        
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
            updateAddCatIconVisibility()
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
        guard !categoryItem.forceDisabled else { return [] }
        let itemProvider = NSItemProvider(object: "\(categoryItem.id.hashValue)" as NSString)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        dragItem.localObject = categoryItem
        return [dragItem]
    }
    
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        if destinationIndexPath == nil { return UICollectionViewDropProposal(operation: .cancel) }
        if categoryFetchedResultsController.object(at: destinationIndexPath!).forceDisabled { return UICollectionViewDropProposal(operation: .cancel) }
        if let _ = session.items.first?.localObject as? Answer { return UICollectionViewDropProposal(operation: .cancel) }
        return UICollectionViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        guard let destinationIndexPath = coordinator.destinationIndexPath, coordinator.proposal.operation == .move else { return }
        
        //Update the collection view
        if let item = coordinator.items.first, let sourceIndexPath = item.sourceIndexPath{
            
            let originCategory = categoryFetchedResultsController.object(at: sourceIndexPath)
            let destinationCategory = categoryFetchedResultsController.object(at: destinationIndexPath)
            
            //Perform the swap on core data
            if moveOnCoreData(objToMove: (originCategory, sourceIndexPath), destinationObj: (destinationCategory, destinationIndexPath)){
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
    
    private func moveOnCoreData(objToMove: (Category, IndexPath), destinationObj: (Category, IndexPath)) -> Bool {
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
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 1
        }else{
            if let answers = answers{
                answerHeaderView?.setSearchBarStatus(enabled: !answers.isEmpty)
            }
            
            //Managing the empty answer message
            if let searchedAnswers = searchedAnswers{
                if searchedAnswers.isEmpty{
                    tableView.setEmptyMessage(AppString.ViewController.emptyAnswers, height: tableViewEmptyMessageHeight)
                }else{
                    tableView.restoreEmptyMessage()
                }
            }
            
            return searchedAnswers != nil ? searchedAnswers!.count : 0
        }
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
            if tableViewEmptyMessageHeight == 0{
                tableViewEmptyMessageHeight = tableView.bounds.height - (cell.bounds.height + SEARCH_BAR_SECTION_HEADER_HEIGHT) + 20
            }
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
        if answer.forceDisabled{
            cell.selectionStyle = .none
            cell.backgroundColor = .lightGray.withAlphaComponent(0.1)
            cell.answerLabel.alpha = 0.2
        }else{
            cell.selectionStyle = .default
            cell.backgroundColor = .none
            cell.answerLabel.alpha = 1
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let searchedAnswers = searchedAnswers, indexPath.section > 0 else { return }
        guard !searchedAnswers[indexPath.row].forceDisabled else { showDisabledAnswer(); return }
        
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
        answers?.insert(answer, at: 0)
        if let answerHeaderView = answerHeaderView{
            if let text = answerHeaderView.searchBar.text, !text.isEmpty{
                if answer.title.lowercased().contains(text.lowercased()) || answer.descr.lowercased().contains(text.lowercased()){
                    searchedAnswers?.insert(answer, at: 0)
                    if searchedAnswers != nil { answersTableView.insertRows(at: [IndexPath(row: 0, section: 1)], with: .automatic) }
                }
                return
            }
        }
        searchedAnswers = answers
        if answers != nil { answersTableView.insertRows(at: [IndexPath(row: 0, section: 1)], with: .automatic) }
        if let answerHeaderView = answerHeaderView {
            answerHeaderView.setSearchBarStatus(enabled: self.answers!.count > 0)
        }
    }
    
    //MARK: HomeHeaderTableViewCell delegate
    func homeHeaderTableViewCellDidPressed(event: HomeHeaderTableViewCell.PressionEvent, withComponentStatus status: Bool) {
        switch event{
        case .AddNew:
            if status{
                let VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "newCategoryViewController") as! NewCategoryViewController
                VC.modalTransitionStyle = .crossDissolve
                VC.modalPresentationStyle = .overFullScreen
                VC.delegate = self
                self.view.endEditing(true)
                self.present(VC, animated: true)
            }else{
                let alert = UIAlertController(title: AppString.Alerts.noMoreCategoriesAvailable, message: AppString.Alerts.noMoreCategoriesAvailableDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: AppString.Alerts.goToPremiumSection, style: .default, handler: {alertAction in
                    let VC: PremiumViewController = UIStoryboard.premium().instantiate()
                    self.view.endEditing(true)
                    self.navigationController?.pushViewController(VC, animated: true)
                }))
                alert.addAction(UIAlertAction(title: AppString.Alerts.no, style: .cancel))
                self.present(alert, animated: true)
            }
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
            let alert = UIAlertController(title: AppString.Alerts.titleAreYouSure, message: AppString.ViewController.deleteCategoryAlertDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: AppString.Alerts.no, style: .cancel))
            alert.addAction(UIAlertAction(title: AppString.Alerts.yes, style: .destructive, handler: { alertAction in
                if let selectedCategory = self.selectedCategory{
                    DataModelManagerPersistentContainer.shared.context.delete(selectedCategory)
                    DataModelManagerPersistentContainer.shared.saveContext()
                }
            }))
            self.present(alert, animated: true)
        case .Share:
            let VC: SharingChooserViewController = UIStoryboard.main().instantiate()
            if let cat = selectedCategory {
                VC.model = CategoryShareModel(from: cat)
            }
            VC.modalTransitionStyle = .crossDissolve
            VC.modalPresentationStyle = .overFullScreen
            self.view.endEditing(true)
            self.present(VC, animated: true)
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        if type == .delete, let indexPath = indexPath, let cat = categoryFetchedResultsController.fetchedObjects?.filter({!$0.forceDisabled}).count{
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
                answersTableView.setEmptyMessage(AppString.ViewController.noCategoryUsable, height: tableViewEmptyMessageHeight)
                answersTableView.reloadSections(IndexSet(integer: 1), with: .fade)
            }
            updateAddCatIconVisibility()
        } else if type != .move {
            answersTableView.reloadData()
        }
    }
}

//MARK: Drag and drop to change position of the answers
extension ViewController: UITableViewDragDelegate, UITableViewDropDelegate {
    
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        guard indexPath.section == 1 else { return [] }
        let answ = searchedAnswers != nil ? searchedAnswers! : (answers != nil ? answers! : [])
        guard answ.count > 0 else { return [] }
        
        let answerItem = answ[indexPath.row]
        guard !answerItem.forceDisabled else { return [] }
        let itemProvider = NSItemProvider(object: "\(answerItem.id.hashValue)" as NSString)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        dragItem.localObject = answerItem
        return [dragItem]
    }
    
    func tableView(_ tableView: UITableView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UITableViewDropProposal {
        if destinationIndexPath?.section == 0 { return UITableViewDropProposal(operation: .cancel) }
        guard let row = destinationIndexPath?.row, row < searchedAnswers?.count ?? 0, !(searchedAnswers?[row].forceDisabled ?? true) else { return UITableViewDropProposal(operation: .cancel) }
        if let _ = session.items.first?.localObject as? Category { return UITableViewDropProposal(operation: .cancel) }
        return UITableViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
    }
    
    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
        guard let destinationIndexPath = coordinator.destinationIndexPath, coordinator.proposal.operation == .move else { return }
        
        //Update the table view
        if let item = coordinator.items.first, let sourceIndexPath = item.sourceIndexPath{
            guard let searchedAnswers = searchedAnswers else { return }
            let originAnswer = searchedAnswers[sourceIndexPath.row]
            let destinationAnswer = searchedAnswers[destinationIndexPath.row]

            //Perform the swap on core data
            if moveOnCoreData(objToMove: (originAnswer, sourceIndexPath), destinationObj: (destinationAnswer, destinationIndexPath)){
                self.answers = {self.answers}()
                tableView.performBatchUpdates( {
                    tableView.deleteRows(at: [sourceIndexPath], with: .automatic)
                    tableView.insertRows(at: [destinationIndexPath], with: .automatic)
                })
                coordinator.drop(item.dragItem, toRowAt: destinationIndexPath)
            }
        }
    }
    
    private func moveOnCoreData(objToMove: (Answer, IndexPath), destinationObj: (Answer, IndexPath)) -> Bool {
        if destinationObj.1.row == 0{
            //Check if the move is on the left bound - index.row == 0
            if ceil(destinationObj.0.order) == destinationObj.0.order{
                objToMove.0.order = destinationObj.0.order + 1
            }else{
                objToMove.0.order = ceil(destinationObj.0.order)
            }
        }else if let count = searchedAnswers?.count, destinationObj.1.row == count-1{
            //Check if the move is on the right bound - index.row == number of abject minus one
            if floor(destinationObj.0.order) == destinationObj.0.order{
                objToMove.0.order = destinationObj.0.order - 1
            }else{
                objToMove.0.order = floor(destinationObj.0.order)
            }
        }else{
            //middle move
            var newOrder: Double = 0.0
            guard let searchedAnswers = searchedAnswers else { return false }
            if objToMove.1.row < destinationObj.1.row{
                let leftAnsw = searchedAnswers[destinationObj.1.row + 1]
                let rightAnsw = searchedAnswers[destinationObj.1.row]
                newOrder = (leftAnsw.order + rightAnsw.order) / 2
            }else{
                let leftAnsw = searchedAnswers[destinationObj.1.row - 1]
                let rightAnsw = searchedAnswers[destinationObj.1.row]
                newOrder = (leftAnsw.order + rightAnsw.order) / 2
            }
            objToMove.0.order = newOrder
        }
        
        return DataModelManagerPersistentContainer.shared.saveContextWithCheck()
    }
    
    //MARK: Method to show custom row when dragging
    func tableView(_ tableView: UITableView, dragPreviewParametersForRowAt indexPath: IndexPath) -> UIDragPreviewParameters? {
        let dragPrevParam: UIDragPreviewParameters = UIDragPreviewParameters()
        guard let cell = tableView.cellForRow(at: indexPath) as? AnswerTableViewCell else { return nil }
        dragPrevParam.visiblePath = UIBezierPath(roundedRect: CGRect(x: 10, y: 0, width: cell.frame.width-20, height: cell.frame.height), cornerRadius: 15)
        return dragPrevParam
    }
    
}

//MARK: Search bar delegate
extension ViewController: UISearchBarDelegate, UISearchTextFieldDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchedAnswers = searchText.isEmpty ? answers : answers?.filter({ answer in
            return answer.title.lowercased().contains(searchText.lowercased()) || answer.descr.lowercased().contains(searchText.lowercased())
        })

        if searchText.isEmpty{
            answersTableView.dragInteractionEnabled = isDragInteractionEnabledBasedOnSearchBar()
        }else{
            answersTableView.dragInteractionEnabled = false
        }

        answersTableView.reloadData()
    }
    
    private func isDragInteractionEnabledBasedOnSearchBar() -> Bool{
        if let answers = answers{
            return answers.count > 1
        }else{
            return false
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        answersTableView.dragInteractionEnabled = isDragInteractionEnabledBasedOnSearchBar()
        searchedAnswers = answers
        searchBar.endEditing(true)
        answersTableView.reloadData()
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        answersTableView.dragInteractionEnabled = isDragInteractionEnabledBasedOnSearchBar()
        textField.endEditing(true)
        return true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
}



