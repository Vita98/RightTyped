//
//  ProPurchaseTableViewCell.swift
//  RightTyped
//
//  Created by Vitandrea Sorino on 24/09/23.
//

import UIKit

class ProPurchaseTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var purchaseDateLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var expirationLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configure()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //MARK: - Configuration
    private func configure(){
        purchaseDateLabel.trailingAnchor.constraint(equalTo: self.centerXAnchor, constant: -5).isActive = true
        expirationLabel.leadingAnchor.constraint(equalTo: self.centerXAnchor, constant: 5).isActive = true
        titleLabel.set(size: 16)
        purchaseDateLabel.set(size: 12)
        priceLabel.set(size: 16)
        expirationLabel.set(size: 12)
    }
    
}
