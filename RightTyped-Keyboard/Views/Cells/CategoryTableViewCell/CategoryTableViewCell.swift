//
//  CategoryTableViewCell.swift
//  RightTyped-Keyboard
//
//  Created by Vitandrea Sorino on 27/05/23.
//

import UIKit
import CoreData

class CategoryTableViewCell: UITableViewCell {

    @IBOutlet private weak var categoryTitleLabel: UILabel!
    @IBOutlet private weak var collectionViewFlowLayout: UICollectionViewFlowLayout! {
        didSet {
            collectionViewFlowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        }
    }
    
    fileprivate var answerFetchedResultsController: NSFetchedResultsController<Answer>?
        
    @IBOutlet private weak var answersCollectionView: UICollectionView!
    var keyboardAppearance: UIKeyboardAppearance?
    
    private var selectedCategory: Category? {
        didSet{
            categoryTitleLabel.text = selectedCategory!.name
            initResultController(category: selectedCategory!)
        }
    }
    
    public var cellDelegate: AnswerCollectionViewCellDelegate?
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    public func configureCell(){
        configureCollectionView()
    }
    
    private func configureCollectionView(){
        answersCollectionView.register(UINib(nibName: "AnswersCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "answersCollectionViewCellID")
        answersCollectionView.dataSource = self
        answersCollectionView.delegate = self
        
        answersCollectionView.backgroundColor = .none
    }
    
    public func textDidChange(appearance: UIKeyboardAppearance){
        keyboardAppearance = appearance
        answersCollectionView.reloadData()
    }
    
    public func setCategory(_ category: Category){
        selectedCategory = category
    }
    
    private func initResultController(category: Category){
        answerFetchedResultsController = Answer.getFetchedResultController(for: category, delegate: self)
        //Extecute the core data fetch
        do {
            try self.answerFetchedResultsController!.performFetch()
        } catch {
            let fetchError = error as NSError
            print("Unable to Perform Fetch Request")
            print("\(fetchError), \(fetchError.localizedDescription)")
        }
    }
}

extension CategoryTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, NSFetchedResultsControllerDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let answers = answerFetchedResultsController?.fetchedObjects else { return 0 }
        return answers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "answersCollectionViewCellID", for: indexPath) as! AnswersCollectionViewCell
        cell.configureCell()
        cell.delegate = cellDelegate
        if let resContr = answerFetchedResultsController{
            let answ = resContr.object(at: indexPath)
            cell.setAnswer(answ)
        }
        
        if let appearance = keyboardAppearance{
            cell.textDidChange(appearance: appearance)
        }
        return cell
    }
}
