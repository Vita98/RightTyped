//
//  PlainPremiumViewController.swift
//  RightTyped
//
//  Created by Vitandrea Sorino on 05/09/23.
//

import UIKit

class PlainPremiumViewController: UIViewController {
    
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
    
    @IBOutlet weak var cardShadowViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var cardShadowViewBottomConstraint: NSLayoutConstraint!
    
    var model: PremiumPageModel?{
        didSet{
            guard let _ = buttonView else { return }
            configureModel()
        }
    }
    private var buttonViewEnabled: Bool = false

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
        if model.subscriptionType == .included || model.subscriptionType == .notASubscription{
            subscriptionTypeLabel.alpha = 0
            priceLabel.text = model.subscriptionType?.value ?? ""
        }else{
            subscriptionTypeLabel.alpha = 1
            subscriptionTypeLabel.text = "/\(model.subscriptionType?.value ?? "")"
        }
        if let price = model.price, let currSym = model.currencySymbol{
            priceLabel.text = "\(currSym) \(price)"
        }
        buttonViewLabel.text = model.buttonTitle
        
        if let _ = model.products?.first{
            if UserDefaultManager.shared.getProPlanStatus(){
                buttonView.enableComponentButtonMode(enabled: false)
                buttonViewLabel.text = AppString.Premium.FirstBasePlan.buttonTitle
                buttonViewEnabled = false
            }else{
                buttonView.enableComponentButtonMode()
                buttonViewEnabled = true
            }
        }else{
            buttonView.enableComponentButtonMode(enabled: false)
            buttonViewEnabled = false
        }
        
        planLabel.text = model.type.value
    }
    
    //MARK: - Events
    @objc private func buttonViewPressed(){
        if buttonViewEnabled{
            //MAKE THE PAYMENT
            guard let product = model?.products?.first else { return }
            StoreKitHelper.shared.buy(product: product)
        }
    }
}

extension PlainPremiumViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model?.stackContent.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlainPremiumTableViewCell", for: indexPath) as! PlainPremiumTableViewCell
        guard let model = model else { return cell }
        cell.configure(with: model.stackContent[indexPath.row], at: indexPath)
        return cell
    }
}
