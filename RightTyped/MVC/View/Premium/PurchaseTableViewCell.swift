//
//  PurchaseTableViewCell.swift
//  RightTyped
//
//  Created by Vitandrea Sorino on 23/09/23.
//

import UIKit

class PurchaseTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.set(size: 16)
        dateLabel.set(size: 12)
        priceLabel.set(size: 16)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
