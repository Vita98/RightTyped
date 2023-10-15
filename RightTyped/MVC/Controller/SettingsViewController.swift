//
//  SettingsViewController.swift
//  RightTyped
//
//  Created by Vitandrea Sorino on 08/07/23.
//

import UIKit
import LocalAuthentication
import MessageUI

class SettingsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var containerView: UIView!
    private let settingsModel = SettingsModelHelper.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBarView()
        setView()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "SettingsTableViewCell", bundle: nil), forCellReuseIdentifier: SettingsTableViewCell.reuseID)
        tableView.backgroundColor = .clear
        tableView.contentInset.bottom = 30
        resetBackButtonText()
    }

    private func setView(){
        self.view.backgroundColor = .backgroundColor
        containerView.applyCustomRoundCorner()
        containerView.dropShadow(shadowType: .contentView)
    }
    
    private func showAuthenticationAlert(successful: Bool, enabled: Bool){
        var ac: UIAlertController?
        if successful && enabled{
            ac = UIAlertController(title: AppString.Biometric.Alerts.biometricEnabledTitle, message: AppString.Biometric.Alerts.biometricEnabledMessage, preferredStyle: .alert)
            ac?.addAction(UIAlertAction(title: AppString.Alerts.ok, style: .default))
        }else if successful && !enabled{
            ac = UIAlertController(title: AppString.Biometric.Alerts.biometricDisabledTitle, message: AppString.Biometric.Alerts.biometricDisabledMessage, preferredStyle: .alert)
            ac?.addAction(UIAlertAction(title: AppString.Alerts.ok, style: .default))
        }else if !successful{
            ac = UIAlertController(title: AppString.Biometric.Alerts.authenticationFailedTitle, message: AppString.Biometric.Alerts.authenticationFailedMessage, preferredStyle: .alert)
            ac?.addAction(UIAlertAction(title: AppString.Alerts.ok, style: .default))
        }
        guard ac != nil else { return }
        self.present(ac!, animated: true)
    }
    
    private func sendEmail(){
        if !MFMailComposeViewController.canSendMail() {
            showMailNotAvailable()
            return
        }
        let composeVC = MFMailComposeViewController()
        composeVC.mailComposeDelegate = self
         
        // Configure the fields of the interface.
        composeVC.setToRecipients([SUPPORT_EMAIL_ADDRESS])
        composeVC.setSubject(AppString.Support.mailSubject)
        composeVC.setMessageBody(AppString.Support.mailBody, isHTML: false)
        self.present(composeVC, animated: true, completion: nil)
    }
    
    //MARK: Alerts
    private func showMailNotAvailable(){
        let alert : GenericResultViewController = UIStoryboard.main().instantiate()
        alert.configure(image: UIImage(named: "warningIcon"), title: AppString.Support.Alerts.serviceNotAvailable.title, description: AppString.Support.Alerts.serviceNotAvailable.descr)
        alert.addButton(withText: AppString.Alerts.ok){ alert.dismiss(animated: true) }
        alert.modalTransitionStyle = .crossDissolve
        alert.modalPresentationStyle = .overFullScreen
        self.present(alert, animated: true)
    }
    
    private func showEmailSent(){
        let alert : GenericResultViewController = UIStoryboard.main().instantiate()
        alert.configure(image: UIImage(named: "tickIcon"), title: AppString.Support.Alerts.emailSent.title, description: AppString.Support.Alerts.emailSent.descr)
        alert.addButton(withText: AppString.Alerts.ok){ alert.dismiss(animated: true) }
        alert.modalTransitionStyle = .crossDissolve
        alert.modalPresentationStyle = .overFullScreen
        self.present(alert, animated: true)
    }
    
    private func showEmailError(){
        let alert : GenericResultViewController = UIStoryboard.main().instantiate()
        alert.configure(image: UIImage(named: "warningIcon"), title: AppString.Support.Alerts.emailError.title, description: AppString.Support.Alerts.emailError.descr)
        alert.addButton(withText: AppString.Alerts.ok){ alert.dismiss(animated: true) }
        alert.modalTransitionStyle = .crossDissolve
        alert.modalPresentationStyle = .overFullScreen
        self.present(alert, animated: true)
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

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return settingsModel.getNumberOfSection()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return settingsModel.getTypeAtIndex(index: section)?.name
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.font = UIFont.customFont(.normal, size: 12)
        header.textLabel?.textColor = UIColor(named: "textColor")
        header.automaticallyUpdatesBackgroundConfiguration = false
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let setTypeEnum = settingsModel.getTypeAtIndex(index: section)?.type{
            return settingsModel.numberOfSettings(for: setTypeEnum)
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SettingsTableViewCell.reuseID, for: indexPath) as! SettingsTableViewCell
        var cellModel = settingsModel.value(at: indexPath)
        
        switch cellModel.itemType{
        case .biometric:
            cellModel.status = UserDefaultManager.shared.getBoolValue(key: UserDefaultManager.BIOMETRIC_ENABLED_KEY)
            cellModel.action = {isEnabled in
                if isEnabled{
                    BiometricHelper.askForBiometric {[weak self] isSuccessful, error in
                        UserDefaultManager.shared.setBoolValue(key: UserDefaultManager.BIOMETRIC_ENABLED_KEY, enabled: isSuccessful)
                        if isSuccessful{
                            self?.showAuthenticationAlert(successful: true, enabled: true)
                        }else{
                            cell.setSwitch(false)
                            self?.showAuthenticationAlert(successful: false, enabled: true)
                        }
                    }
                }else{
                    BiometricHelper.askForBiometric {[weak self] isSuccessful, error in
                        if isSuccessful{
                            UserDefaultManager.shared.setBoolValue(key: UserDefaultManager.BIOMETRIC_ENABLED_KEY, enabled: false)
                            self?.showAuthenticationAlert(successful: true, enabled: false)
                        }else{
                            cell.setSwitch(true)
                            self?.showAuthenticationAlert(successful: false, enabled: false)
                        }
                    }
                }
            }
        case .goBackToDefaultKeyboard:
            cellModel.status = UserDefaultManager.shared.getBoolValue(key: UserDefaultManager.GO_BACK_TO_DEF_KEYBOARD_KEY)
            cellModel.action = { isEnabled in
                UserDefaultManager.shared.setBoolValue(key: UserDefaultManager.GO_BACK_TO_DEF_KEYBOARD_KEY, enabled: isEnabled)
            }
        default:
            break
        }
        
        cell.setModel(cellModel: cellModel)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellModel = settingsModel.value(at: indexPath)
        
        switch cellModel.type{
        case .Tutorial:
            if cellModel.itemType == .howToEnableKeyboard{
                guard let rNC = UINavigationController.instantiateNavController(withRoot: EnableKeyboardViewController.self) else { break }
                rNC.root.fromSettings = true
                self.present(rNC.navController, animated: true)
            }else{
                guard let rNC = UINavigationController.instantiateNavController(withRoot: ManagerTutorialViewController.self) else { break }
                rNC.root.model = SettingsModelHelper.getTutorial(for: cellModel.itemType)
                rNC.root.fromSettings = true
                self.present(rNC.navController, animated: true)
            }
        case .App:
            switch cellModel.itemType{
            case .myPurchases:
                let cv: MyPurchasesViewController = UIStoryboard.premium().instantiate()
                self.navigationController?.pushViewController(cv, animated: true)
            case .premium:
                let cv: PremiumViewController = UIStoryboard.premium().instantiate()
                self.navigationController?.pushViewController(cv, animated: true)
            default:
                break
            }
        case .Support:
            switch cellModel.itemType{
            case .contactSupport:
                sendEmail()
            default: break
            }
        default:
            break
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension SettingsViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        var completion: (() -> Void)?
        switch result{
        case .failed:
            completion = showEmailError
        case .sent:
            completion = showEmailSent
        default: break
        }
        controller.dismiss(animated: true, completion: {completion?()})
    }
}
