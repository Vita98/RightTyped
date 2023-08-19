//
//  MyPurchasesViewController.swift
//  RightTyped
//
//  Created by Vitandrea Sorino on 19/08/23.
//

import UIKit

class MyPurchasesViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var containerView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBarView()
        setView()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "SettingsTableViewCell", bundle: nil), forCellReuseIdentifier: SettingsTableViewCell.reuseID)
        tableView.backgroundColor = .clear
    }
    
    //MARK: - Configuration
    private func setView(){
        self.view.backgroundColor = .backgroundColor
        containerView.applyCustomRoundCorner()
        containerView.dropShadow(shadowType: .contentView)
        titleLabel.text = AppString.SettingsModel.myPurchasesText
    }
    
    private func setEmptyView(){
        tableView.setEmptyViewForPurchases(withButtonText: AppString.Premium.MyPurchases.restorePurchasesButtonTitle, topLabelText: AppString.Premium.MyPurchases.noPurchasesFound) {
            //TODO: Implement the action to restore all purchases from the app store
        }
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

extension MyPurchasesViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        setEmptyView()
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
