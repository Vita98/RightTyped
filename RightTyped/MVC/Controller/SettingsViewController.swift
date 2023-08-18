//
//  SettingsViewController.swift
//  RightTyped
//
//  Created by Vitandrea Sorino on 08/07/23.
//

import UIKit
import LocalAuthentication

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
                tableView.deselectRow(at: indexPath, animated: true)
            }else{
                guard let rNC = UINavigationController.instantiateNavController(withRoot: ManagerTutorialViewController.self) else { break }
                rNC.root.model = SettingsModelHelper.getTutorial(for: cellModel.itemType)
                rNC.root.fromSettings = true
                self.present(rNC.navController, animated: true)
                tableView.deselectRow(at: indexPath, animated: true)
            }
        default:
            break
        }
    }
}
