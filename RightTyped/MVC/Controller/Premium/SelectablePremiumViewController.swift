//
//  SelectablePremiumViewController.swift
//  RightTyped
//
//  Created by Vitandrea Sorino on 07/09/23.
//

import UIKit
import StoreKit

class SelectablePremiumViewController: UIViewController {
    
    //MARK: - Outlet
    @IBOutlet weak var buttonView: UIView!
    @IBOutlet weak var buttonViewLabel: UILabel!
    @IBOutlet weak var buttonShadowView: UIView!
    @IBOutlet weak var planLabel: UILabel!
    @IBOutlet weak var planView: UIView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var subscriptionTypeLabel: UILabel!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var cardShadowView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noteLabel: UILabel!
    
    @IBOutlet weak var cardShadowViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var cardShadowViewBottomConstraint: NSLayoutConstraint!
    
    
    var model: PremiumPageModel?{
        didSet{
            guard let _ = buttonView else { return }
            configureModel()
        }
    }
    
    private var indexSelected: Int? = nil
    private var productSelected: PremiumStackContent? = nil
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        configureModel()
    }
    
    override func viewDidLayoutSubviews() {
        cardView.clipsToBounds = true
        cardView.layer.cornerRadius = 10
        cardShadowView.dropShadow(shadowType: .tutorialGifShadow)
        cardShadowView.layer.cornerRadius = 10
        
        buttonView.clipsToBounds = true
        buttonView.layer.cornerRadius = 5
        buttonShadowView.dropShadow(shadowType: .tutorialGifShadow)
        buttonShadowView.layer.cornerRadius = 5
    }
    
    //MARK: - Configuration
    private func configure(){
        setTextsAndFonts()
        configurePlanType()
        tableView.register(UINib(nibName: "PlainPremiumTableViewCell", bundle: nil), forCellReuseIdentifier: "PlainPremiumTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.alwaysBounceVertical = false
        
        if !UIDevice.current.isSmall(){
            cardShadowViewTopConstraint.constant = 40
            cardShadowViewBottomConstraint.constant = 40
        }
        buttonView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(buttonViewPressed)))
    }
    
    private func setTextsAndFonts(){
        descriptionLabel.set(size: 18)
        priceLabel.set(font: .customFont(.alt, size: 36))
        subscriptionTypeLabel.set(font: .customFont(.alt, size: 18))
        buttonViewLabel.set(size: 24)
        planLabel.set(size: 16)
        noteLabel.set(size: 12)
    }
    
    private func configurePlanType(){
        let cellModel = CategoryCell(isSelected: true)
        planView.layer.cornerRadius = 14
        planView.layer.borderWidth = 1
        
        planView.dropShadow(shadowType: .categoryAppCollectionViewCell)
        planView.backgroundColor = cellModel.selectedStyle.backgroundColor
        planView.layer.borderColor = cellModel.selectedStyle.borderColor.cgColor
        planLabel.font = UIFont.customFont(.alt, size: 16)
    }
    
    private func configureModel(){
        guard let model = model else { return }
        descriptionLabel.text = model.description
        subscriptionTypeLabel.text = "/\(model.subscriptionType?.value ?? "")"
        buttonView.enableComponentButtonMode(enabled: false)
        
        if model.subscriptionType != .aggregated{
            subscriptionTypeLabel.alpha = 0
        }else if !model.stackContent.isEmpty, let first = model.stackContent.first, let currSym = first.currencySymbol{
            priceLabel.text = "\(currSym) 0.00"
            buttonViewLabel.text = model.buttonTitle
            planLabel.text = model.type.value
        }
        
        guard let note = model.note else {
            noteLabel.isHidden = true
            noteLabel.heightAnchor.constraint(equalToConstant: 0).isActive = true
            return
        }
        noteLabel.text = note
    }
    
    private func setPrice(_ price: Double, currencySymbol: String){
        priceLabel.text = "\(currencySymbol) \(String(format: "%.2f", price))"
    }
    
    //MARK: - Events
    @objc private func buttonViewPressed(){
        if let productSelected = productSelected, let product = productSelected.product{
            //MAKE THE PAYMENT
            StoreKitHelper.shared.buy(product: product)
        }
    }

}

extension SelectablePremiumViewController: UITableViewDelegate, UITableViewDataSource, PremiumTableViewCellDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model?.stackContent.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlainPremiumTableViewCell", for: indexPath) as! PlainPremiumTableViewCell
        guard let model = model else { return cell }
        cell.configure(with: model.stackContent[indexPath.row], at: indexPath)
        cell.setStatus(indexSelected == indexPath.row)
        cell.delegate = self
        return cell
    }
    
    func statusChanged(product: PremiumStackContent, selected: Bool, at index: Int) {
        if selected{
            self.indexSelected = index
            self.productSelected = product
            setPrice(product.price ?? 0.0, currencySymbol: product.currencySymbol ?? "")
        }else{
            self.indexSelected = nil
            self.productSelected = nil
            setPrice(0.0, currencySymbol: product.currencySymbol ?? "")
        }
        buttonView.enableComponentButtonMode(enabled: selected, animated: true)
        tableView.reloadData()
    }
}
