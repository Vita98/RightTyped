//
//  PlainPremiumTableViewCell.swift
//  RightTyped
//
//  Created by Vitandrea Sorino on 10/09/23.
//

import UIKit
import StoreKit

protocol PremiumTableViewCellDelegate{
    func statusChanged(product: PremiumStackContent, selected: Bool, at index: Int)
}

class PlainPremiumTableViewCell: UITableViewCell {
    
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var contentImageView: UIImageView!
    
    private var model: PremiumStackContent?
    private var checkboxStatus: Bool = false
    private var index: Int?
    var delegate: PremiumTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public func configure(with stackContent: PremiumStackContent, at index: IndexPath){
        self.contentLabel.text = stackContent.title
        self.model = stackContent
        self.index = index.row
        
        switch stackContent.type{
        case .plainItem:
            if stackContent.included{
                self.contentImageView.image = UIImage(named: "plainTickIcon")
            }else{
                self.contentImageView.image = UIImage(named: "plainCrossIcon")
            }
        case .selectableItem:
            contentImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(checkboxStatusChanged)))
            if let price = model?.price, let currSym = model?.currencySymbol, let actText = contentLabel.text{
                contentLabel.text = actText + " ( \(currSym) \(String(format: "%.2f", price)) )"
            }
            if stackContent.included{
                self.contentImageView.image = UIImage(named: "checkboxChecked")
            }else{
                self.contentImageView.image = UIImage(named: "checkboxUnchecked")
            }
        }
    }
    
    public func setStatus(_ status: Bool){
        self.contentImageView.image = UIImage(named: status ? "checkboxChecked" : "checkboxUnchecked")
        checkboxStatus = status
    }
    
    //MARK: - Events
    @objc private func checkboxStatusChanged(){
        if checkboxStatus{
            self.contentImageView.image = UIImage(named: "checkboxUnchecked")
        }else{
            self.contentImageView.image = UIImage(named: "checkboxChecked")
        }
        checkboxStatus = !checkboxStatus
        guard let model = model, let index = self.index else { return }
        delegate?.statusChanged(product: model, selected: checkboxStatus, at: index)
    }
    
    
}
