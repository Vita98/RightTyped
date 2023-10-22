//
//  SelectCategoriesViewController.swift
//  RightTyped
//
//  Created by Vitandrea Sorino on 07/10/23.
//

import UIKit
import CoreData

protocol SelectCategoriesViewControllerDelegate{
    func selectCategoriesViewControllerChangesMade()
}

class SelectCategoriesViewController: UIViewController, NSFetchedResultsControllerDelegate {
    
    //MARK: - Outlet
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: SelfSizedTableView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var selectionLabel: UILabel!
    @IBOutlet weak var buttonView: UIView!
    @IBOutlet weak var buttonViewTitle: UILabel!
    @IBOutlet weak var bottomContainerView: UIView!
    
    //MARK: - custom variables
    private var maximumSelectable: Int = Product.getMaximumCategoriesCount()
    fileprivate lazy var categoryFetchedResultsController: NSFetchedResultsController<Category> = Category.getFetchedResultControllerForAllCategory(delegate: self)
    private var selectedCategories: [Category] = []
    public var delegate: SelectCategoriesViewControllerDelegate?
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        overrideBackAction(action: #selector(backTouch))
    }
    
    //MARK: - Configuration
    private func configure(){
        setNavigationBarView()
        setView()
        setTableView()
        setTextsAndFonts()
        
        //Performing the core data fetch
        do {
            try self.categoryFetchedResultsController.performFetch()
        } catch {
            let fetchError = error as NSError
            print("Unable to Perform Fetch Request")
            print("\(fetchError), \(fetchError.localizedDescription)")
        }
    }
    
    private func setTextsAndFonts(){
        titleLabel.set(size: 24)
        descriptionLabel.set(size: 14)
        selectionLabel.set(size: 20)
        buttonViewTitle.set(size: 24)
    }
    
    private func setView(){
        self.view.backgroundColor = .backgroundColor
        containerView.applyCustomRoundCorner()
        bottomContainerView.backgroundColor = .backgroundColor?.withAlphaComponent(0.85)
        bottomContainerView.applyCustomRoundCorner(10)
        containerView.dropShadow(shadowType: .contentView)
        titleLabel.text = AppString.Premium.SelectCategories.mainTitle
        descriptionLabel.text = String(format: AppString.Premium.SelectCategories.mainDescription, maximumSelectable, MAXIMUM_CATEGORIES_AVAILABLE)
        setRightBarButtonItem(imageName: "infoIcon", gestureRecognizer: UITapGestureRecognizer(target: self, action: #selector(infoButtonTapped)), withSize: CGSize(width: 30, height: 30))
        selectionLabel.text = String(format: AppString.Premium.SelectCategories.selectionText, selectedCategories.count, maximumSelectable)
        buttonView.enableComponentButtonMode(enabled: false, animated: false)
        buttonViewTitle.text = AppString.General.save
    }
    
    private func setTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SelectionCategoryTableViewCell.self)
        tableView.contentInset.bottom = 150
    }
    
    private func updateSelection(){
        selectionLabel.text = String(format: AppString.Premium.SelectCategories.selectionText, selectedCategories.count, maximumSelectable)
        buttonView.enableComponentButtonMode(enabled: selectedCategories.count == maximumSelectable, animated: true)
        buttonView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(saveButtonPressed)))
    }
    
    //MARK: - Events
    @objc private func infoButtonTapped(){
        let alert : GenericResultViewController = UIStoryboard.main().instantiate()
        alert.configure(image: UIImage(named: "infoIcon"), description: String(format: AppString.Premium.SelectCategories.infoPopupDescription, MAXIMUM_ANSWERS_FOR_CATEGORIES))
        alert.addButton(withText: AppString.General.close){
            alert.dismiss(animated: true)
        }
        alert.modalTransitionStyle = .crossDissolve
        alert.modalPresentationStyle = .overFullScreen
        self.present(alert, animated: true)
    }
    
    @objc private func saveButtonPressed(){
        guard selectedCategories.count == maximumSelectable else { return }
        let alert : GenericResultViewController = UIStoryboard.main().instantiate()
        alert.configure(image: UIImage(named: "warningIcon"), title: AppString.Alerts.titleAreYouSure , description: AppString.Premium.Popup.AreSureAboutSelection.description)
        alert.addButton(withText: AppString.Alerts.yes){[weak self] in
            guard let strongSelf = self else { return }
            Category.forceDisableAll(except: strongSelf.selectedCategories)
            Answer.forceDisableAllExceedingAnswers(forMaximum: MAXIMUM_ANSWERS_FOR_CATEGORIES)
            UserDefaultManager.shared.setBoolValue(key: UserDefaultManager.PRO_PLAN_HAS_JUST_BEEN_DISABLED, enabled: false)
            strongSelf.delegate?.selectCategoriesViewControllerChangesMade()
            alert.dismiss(animated: true, completion: {[weak self] in self?.navigationController?.popViewController(animated: true)})
        }
        alert.addButton(withText: AppString.Alerts.no){
            alert.dismiss(animated: true)
        }
        alert.modalTransitionStyle = .crossDissolve
        alert.modalPresentationStyle = .overFullScreen
        self.present(alert, animated: true)
    }
    
    @objc private func backTouch(){
        self.navigationController?.popViewController(animated: true)
    }
}

//MARK: Table view manager
extension SelectCategoriesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryFetchedResultsController.fetchedObjects?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: SelectionCategoryTableViewCell = tableView.dequeue(for: indexPath) else { return UITableViewCell() }
        let category = categoryFetchedResultsController.object(at: indexPath)
        cell.titleLabel.text = category.name
        cell.associatedCategory = category
        cell.delegate = self
        return cell
    }
}

//MARK: Selection manager
extension SelectCategoriesViewController: SelectionCategoryTableViewCellDelegate{
    
    func SelectionCategoryTableViewCellStatusChanged(selected: Bool, associatedCategory: Category?) {
        guard let associatedCategory = associatedCategory else { return }
        let contained = selectedCategories.contains(associatedCategory)
        
        if !selected, contained{
            selectedCategories.removeAll(where: {$0.id == associatedCategory.id})
        }else if selected, !contained {
            selectedCategories.append(associatedCategory)
        }
        updateSelection()
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return selectedCategories.count < maximumSelectable ? indexPath : nil
    }
}
