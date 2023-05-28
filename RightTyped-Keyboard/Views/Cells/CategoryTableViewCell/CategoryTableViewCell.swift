//
//  CategoryTableViewCell.swift
//  RightTyped-Keyboard
//
//  Created by Vitandrea Sorino on 27/05/23.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {

    @IBOutlet weak var collectionViewFlowLayout: UICollectionViewFlowLayout! {
        didSet {
            collectionViewFlowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        }
    }
        
    @IBOutlet weak var answersCollectionView: UICollectionView!
    var keyboardAppearance: UIKeyboardAppearance?
    
    
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
    
}

extension CategoryTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return NUMBER_OF_ANSWERS
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "answersCollectionViewCellID", for: indexPath) as! AnswersCollectionViewCell
        cell.configureCell()
        cell.setAnswer(text: ANSWERS[indexPath.row])
        if let appearance = keyboardAppearance{
            cell.textDidChange(appearance: appearance)
        }
        return cell
    }
}
