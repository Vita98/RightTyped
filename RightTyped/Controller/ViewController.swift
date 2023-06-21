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
    
    @IBOutlet weak var tableShadowView: UIView!
    @IBOutlet weak var answersTableView: UITableView!
    
    var categories = [Category]()
    fileprivate lazy var categoryFetchedResultsController: NSFetchedResultsController<Category> = Category.getFetchedResultControllerForAllCategory(delegate: self)
    var selectedCategory : Category?
    var answers: [Answer]?
    var searchedAnswers: [Answer]?
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addObservers()
        configureView()
        configureAnswersTableView()
        
        //Performing the core data fetch
        do {
            try self.categoryFetchedResultsController.performFetch()
        } catch {
            let fetchError = error as NSError
            print("Unable to Perform Fetch Request")
            print("\(fetchError), \(fetchError.localizedDescription)")
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
extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, NSFetchedResultsControllerDelegate{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let categories = categoryFetchedResultsController.fetchedObjects else { return 0 }
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.reuseID, for: indexPath) as! CategoryCollectionViewCell
        let category = categoryFetchedResultsController.object(at: indexPath)
        cell.label.text = category.name
        
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
}

//MARK: Answers table view delegate and datasource
extension ViewController: UITableViewDelegate, UITableViewDataSource, NewAnswerViewControllerDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 1
        }else{
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
    
    func newAnswerViewController(didChange answer: Answer, at originIndexPath: IndexPath?) {
        if let indexPath = originIndexPath{
            answersTableView.reloadRows(at: [indexPath], with: .fade)
        }else{
            answersTableView.reloadData()
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



