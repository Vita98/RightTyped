//
//  PremiumViewController.swift
//  RightTyped
//
//  Created by Vitandrea Sorino on 18/08/23.
//

import UIKit
import StoreKit

class PremiumViewController: UIViewController {

    @IBOutlet weak var premiumLabel: UILabel!
    @IBOutlet weak var navigateRightButton: UIButton!
    @IBOutlet weak var navigateLeftButton: UIButton!
    @IBOutlet weak var pageControlContainerView: UIView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var activityIndicator: CustomActivityIndicatorView!
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var emptyLabel: UILabel!
    @IBOutlet weak var emptyButtonView: UIView!
    @IBOutlet weak var emptyButtonLabel: UILabel!
    
    //MARK: Custom component
    var pageViewController: CustomPageViewController?
    var loadingViewController: LoadingViewController?
    
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        setNavigationBarView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        overrideBackAction(action: #selector(backTouch))
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is CustomPageViewController{
            pageViewController = segue.destination as? CustomPageViewController
            pageViewController?.navigateLeftButton = navigateLeftButton
            pageViewController?.navigateRightButton = navigateRightButton
        }
    }
    
    //MARK: - Configuration
    private func configure(){
        setNavigationBarView()
        premiumLabel.textColor = .componentColor
        view.backgroundColor = .backgroundColor
        
        //page control section
        activityIndicator.startAnimating()
        navigateRightButton.setTitle("", for: .normal)
        navigateLeftButton.setTitle("", for: .normal)
        navigateLeftButton.setImage(navigateLeftButton.image(for: .normal)?.withTintColor(.componentColor.disabled()), for: .normal)
        pageControlContainerView.layer.cornerRadius = 12.5
        pageControl.layer.cornerRadius = 12.5
        pageControl.backgroundStyle = .minimal
        pageControl.numberOfPages =  0
        pageViewController?.pageControl = self.pageControl
        
        configureEmptyView()
        setComponentStatus(false)
        activityIndicator.hidesWhenStopped = true
        StoreKitHelper.shared.fetchProducts(delegate: self)
    }
    
    private func configureEmptyView(){
        emptyLabel.text = AppString.Premium.PremiumPage.noPremiumOptions
        emptyButtonLabel.text = AppString.Premium.PremiumPage.refreshButtonTitle
        activityIndicator.startAnimating()
        emptyButtonView.enableComponentButtonMode(enabled: true)
        emptyButtonView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(refreshButtonPressed)))
        emptyView.alpha = 0
    }
    
    private func setComponentStatus(_ status: Bool){
        pageControlContainerView.alpha = status ? 1 :0
        navigateLeftButton.alpha = status ? 1 :0
        navigateRightButton.alpha = status ? 1 :0
    }
    
    private func showEmptyView(_ status: Bool){
        setComponentStatus(false)
        if status{
            activityIndicator.stopAnimating()
            emptyView.alpha = 1
        }else{
            activityIndicator.startAnimating()
            emptyView.alpha = 0
        }
        
    }
    
    private func toggleLoadingViewController(){
        if let loadingViewController = loadingViewController{
            loadingViewController.dismiss(animated: true)
            self.loadingViewController = nil
        }else{
            loadingViewController = LoadingViewController()
            loadingViewController?.show(in: self)
        }
    }
    
    //MARK: - Event
    @objc private func refreshButtonPressed(){
        showEmptyView(false)
        StoreKitHelper.shared.fetchProducts(delegate: self)
    }
    
    @objc private func backTouch(){
        self.navigationController!.popViewController(animated: true)
    }
}

extension PremiumViewController: StoreKitHelperDelegate{
    func productListFound(products: [String : SKProduct]?) {
        DispatchQueue.main.sync {
            activityIndicator.stopAnimating()
            guard let products = products else {
                showEmptyView(true)
                return
            }
            Premium.inflateWith(products: Array(products.values))
            
            //Show the pages
            if let pageViewController = pageViewController{
                pageViewController.initialPageIndex = 1
                pageViewController.model = Premium.PREMIUMS
            }
            
            setComponentStatus(true)
            if let emptyView = emptyView{
                emptyView.removeFromSuperview()
            }
        }
    }
    
    func paymentProcessDone(of productId: String, withStatus status: PaymentStatus) {
        toggleLoadingViewController()
        let alert: PremiumResultViewController = UIStoryboard.premium().instantiate()
        alert.modalTransitionStyle = .crossDissolve
        alert.modalPresentationStyle = .overFullScreen
        alert.closeClosure = {[weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        if status == .purchased{
            guard let prod = Products.fromId(id: productId) else { return }
            
            if prod != .YearlyProPlan{
                if Product.saveBoughtProduct(prod){
                    alert.configure(for: .success, with: prod)
                }else{
                    alert.configure(for: .failure, with: prod)
                }
            }else{
                alert.configure(for: .success, with: prod)
                if ReceiptValidatorHelper.shared.checkReceipt(){
                    UserDefaultManager.shared.setBoolValue(key: UserDefaultManager.PRO_PLAN_ENABLED_KEY, enabled: true)
                    UserDefaultManager.shared.setBoolValue(key: UserDefaultManager.PRO_PLAN_HAS_JUST_BEEN_DISABLED, enabled: false)
                }else{
                    alert.configure(for: .failure, with: prod)
                }
            }
        }else{
            guard let prod = Products.fromId(id: productId) else { return }
            alert.configure(for: .failure, with: prod)
        }
        self.present(alert, animated: true)
    }
    
    func paymentInProcess(of productId: String) {
        toggleLoadingViewController()
    }
}
