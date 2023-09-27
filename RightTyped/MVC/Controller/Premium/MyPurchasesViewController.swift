//
//  MyPurchasesViewController.swift
//  RightTyped
//
//  Created by Vitandrea Sorino on 19/08/23.
//

import UIKit
import StoreKit
import TPInAppReceipt

class MyPurchasesViewController: UIViewController {
    
    //MARK: - Outlet
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: SelfSizedTableView!
    @IBOutlet weak var containerView: UIView!
    
    //MARK: - Custom Component
    private var allTransactions: [InAppTransaction]?
    private var ppuPurchases: [InAppTransaction]?
    private var proPurchases: [InAppTransaction]?
    private var sectionsTitle: [String]? = []
    private var aggregatedPurchases: [[PremiumType: [InAppTransaction]]] = []
    private var receiptProPurchase: [InAppPurchase] = []
    var loadingViewController: LoadingViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBarView()
        setView()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(PurchaseTableViewCell.self)
        tableView.register(ProPurchaseTableViewCell.self)
        tableView.backgroundColor = .clear
        
        refreshPage()
    }
    
    //MARK: - Configuration
    private func setView(){
        self.view.backgroundColor = .backgroundColor
        containerView.applyCustomRoundCorner()
        containerView.dropShadow(shadowType: .contentView)
        titleLabel.text = AppString.SettingsModel.myPurchasesText
    }
    
    private func setEmptyView(){
        tableView.setEmptyViewForPurchases(withButtonText: AppString.Premium.MyPurchases.restorePurchasesButtonTitle, topLabelText: AppString.Premium.MyPurchases.noPurchasesFound) {[weak self] in
            self?.toggleLoadingViewController()
            StoreKitHelper.shared.restorePurchase(delegate: self)
        }
    }
    
    private func toggleLoadingViewController(animated: Bool = true, completion: (() -> Void)? = nil){
        if let loadingViewController = loadingViewController{
            loadingViewController.dismiss(animated: animated, completion: completion)
            self.loadingViewController = nil
        }else{
            loadingViewController = LoadingViewController()
            loadingViewController?.show(in: self)
        }
    }
    
    private func refreshPage(){
        allTransactions = InAppTransaction.getAllTransactions()
        receiptProPurchase = ReceiptValidatorHelper.shared.getAllProPlans()
        
        let ids = receiptProPurchase.map({$0.transactionIdentifier})
        proPurchases = allTransactions?.filter({ids.contains($0.transactionId)})
        ppuPurchases = allTransactions?.filter({!ids.contains($0.transactionId)})
        
        if proPurchases?.count != 0{
            aggregatedPurchases.append([PremiumType.pro: proPurchases ?? []])
        }
        
        if ppuPurchases?.count != 0{
            aggregatedPurchases.append([PremiumType.payPerUse: ppuPurchases ?? []])
        }
        
        if let purchCount = proPurchases?.count, purchCount > 0{
            sectionsTitle?.append(AppString.Premium.Plans.proText)
        }
        if let transCount = ppuPurchases?.count, transCount > 0{
            sectionsTitle?.append(AppString.Premium.Plans.ppuText)
        }
        
        if sectionsTitle?.count == 0{
            setEmptyView()
        }else{
            tableView.restoreEmptyMessage()
        }
        
        tableView.reloadData()
    }
    
    //MARK: Controller lifecycle
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        overrideBackAction(action: #selector(goBack))
    }
    
    //MARK: Events
    @objc func goBack() {
        navigationController?.popViewController(animated: true)
    }
}

extension MyPurchasesViewController: StoreKitRestoreHelperDelegate{
    func paymentRestored(with transaction: SKPaymentTransaction) { return }
    
    func restoreEnded(with error: Error?) {
        guard error == nil else {
            self.toggleLoadingViewController(animated: true){[weak self] in
                let alert : GenericResultViewController = UIStoryboard.main().instantiate()
                alert.configure(image: UIImage(named: "warningIcon"), title: AppString.Premium.Popup.ErrorRestoringPurchase.title, description: AppString.Premium.Popup.ErrorRestoringPurchase.description)
                alert.withCloseButton = true
                alert.modalTransitionStyle = .crossDissolve
                alert.modalPresentationStyle = .overFullScreen
                self?.present(alert, animated: true)
            }
            return
        }
        
        ReceiptValidatorHelper.shared.updateProPlanStatus(){ [weak self] isProPlanActive, expirationDate in
            if isProPlanActive, let expirationDate = expirationDate{
                self?.toggleLoadingViewController(animated: true){[weak self] in
                    let alert : GenericResultViewController = UIStoryboard.main().instantiate()
                    alert.configure(image: UIImage(named: "tickIcon"), title: AppString.Premium.Popup.SuccessProRestoration.title, description: String(format: AppString.Premium.Popup.SuccessProRestoration.description, DateFormatter.getFormatted(expirationDate)))
                    alert.withCloseButton = true
                    alert.modalTransitionStyle = .crossDissolve
                    alert.modalPresentationStyle = .overFullScreen
                    self?.present(alert, animated: true)
                }
            }else{
                self?.toggleLoadingViewController(animated: true){[weak self] in
                    let alert : GenericResultViewController = UIStoryboard.main().instantiate()
                    alert.configure(image: UIImage(named: "warningIcon"), title: AppString.Premium.Popup.NothingToRestore.title, description: AppString.Premium.Popup.NothingToRestore.description)
                    alert.withCloseButton = true
                    alert.modalTransitionStyle = .crossDissolve
                    alert.modalPresentationStyle = .overFullScreen
                    self?.present(alert, animated: true)
                }
            }
            self?.refreshPage()
        }
    }
}

extension MyPurchasesViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return aggregatedPurchases.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionsTitle?[section]
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.font = UIFont.customFont(.normal, size: 12)
        header.textLabel?.textColor = UIColor(named: "textColor")
        header.automaticallyUpdatesBackgroundConfiguration = false
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return aggregatedPurchases[section].first?.value.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if aggregatedPurchases[indexPath.section].first?.key == .pro, let proPurchases = aggregatedPurchases[indexPath.section].first?.value{
            guard let cell: ProPurchaseTableViewCell = tableView.dequeue(for: indexPath) else { return UITableViewCell() }
            let trans = proPurchases[indexPath.row]
            cell.titleLabel.text = trans.purchaseDescription
            if trans.pricePaid == nil{
                cell.priceLabel.isHidden = true
            }else{
                cell.priceLabel.text = String(format: "%.2f \(trans.locale)", trans.pricePaid as! Double)
                cell.priceLabel.isHidden = false
            }
            cell.purchaseDateLabel.text = String(format: AppString.Premium.MyPurchases.purchaseDate, DateFormatter.getFormatted(trans.purchaseDate))
            
            let expDate = receiptProPurchase.filter({$0.originalTransactionIdentifier == trans.transactionId}).first?.subscriptionExpirationDate ?? Date()
            cell.expirationLabel.text = String(format: AppString.Premium.MyPurchases.expirationDate, DateFormatter.getFormatted(expDate)) 
            return cell
        }else if aggregatedPurchases[indexPath.section].first?.key == .payPerUse, let ppuPurchases = aggregatedPurchases[indexPath.section].first?.value{
            guard let cell: PurchaseTableViewCell = tableView.dequeue(for: indexPath) else { return UITableViewCell() }
            let trans = ppuPurchases[indexPath.row]
            cell.titleLabel.text = trans.purchaseDescription
            cell.priceLabel.text = String(format: "%.2f \(trans.locale)", trans.pricePaid as! Double)
            cell.dateLabel.text = String(format: AppString.Premium.MyPurchases.purchaseDate, DateFormatter.getFormatted(trans.purchaseDate))
            return cell
        }
        return UITableViewCell()
    }
}
