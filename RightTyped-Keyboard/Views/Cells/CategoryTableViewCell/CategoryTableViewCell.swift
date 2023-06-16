//
//  CategoryTableViewCell.swift
//  RightTyped-Keyboard
//
//  Created by Vitandrea Sorino on 27/05/23.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {

    @IBOutlet private weak var categoryTitleLabel: UILabel!
    @IBOutlet private weak var collectionViewFlowLayout: UICollectionViewFlowLayout! {
        didSet {
            collectionViewFlowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        }
    }
        
    @IBOutlet private weak var answersCollectionView: UICollectionView!
    var keyboardAppearance: UIKeyboardAppearance?
    private var selectedCategory: Category? {
        didSet{
            categoryTitleLabel.text = selectedCategory!.name
            
            if let answers = selectedCategory!.answers?.allObjects as? [Answer]{
                enabledAnswers = answers.filter { answer in answer.enabled }
                answersCollectionView.reloadData()
            }
        }
    }
    
    private var enabledAnswers: [Answer]?
    
    
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
    
}

extension CategoryTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return enabledAnswers != nil ? enabledAnswers!.count : 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "answersCollectionViewCellID", for: indexPath) as! AnswersCollectionViewCell
        cell.configureCell()
        if let answ = enabledAnswers{
            cell.setAnswer(answ[indexPath.row])
        }
        if let appearance = keyboardAppearance{
            cell.textDidChange(appearance: appearance)
        }
        return cell
    }
}
