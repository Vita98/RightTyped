//
//  SettingsViewController.swift
//  RightTyped
//
//  Created by Vitandrea Sorino on 08/07/23.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var containerView: UIView!
    private let model = SettingsModelHelper.values
    
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
        containerView.backgroundColor = .white
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
        return SettingsTypeEnum.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return SettingsTypeEnum.getTypeAtIndex(index: section)?.name
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.font = UIFont.customFont(.normal, size: 12)
        header.textLabel?.textColor = .black
        header.automaticallyUpdatesBackgroundConfiguration = false
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let setTypeEnum = SettingsTypeEnum.getTypeEnumAtIndex(index: section){
            return SettingsModelHelper.numberOfTutorial(for: setTypeEnum)
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SettingsTableViewCell.reuseID, for: indexPath) as! SettingsTableViewCell
        var cellModel = SettingsModelHelper.value(at: indexPath)
        
        switch cellModel.itemType{
        case .touchID:
            //TODO: Configure the cellModel.status
            cellModel.action = {[weak self] isEnabled in
                guard let strongSelf = self else { return }
                //TODO: do all the thing to enable or disable the touch id
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
        let cellModel = SettingsModelHelper.value(at: indexPath)
        
        switch cellModel.itemType{
        case .howToEnableKeyboard:            
            guard let rNC = UINavigationController.instantiateNavController(withRoot: EnableKeyboardViewController.self) else { break }
            rNC.root.fromSettings = true
            self.present(rNC.navController, animated: true)
            tableView.deselectRow(at: indexPath, animated: true)
        case .howToUseKeyboard:
            guard let rNC = UINavigationController.instantiateNavController(withRoot: ManagerTutorialViewController.self) else { break }
            rNC.root.model = Tutorials.HOW_TO_USE_KEYBOARD
            rNC.root.fromSettings = true
            self.present(rNC.navController, animated: true)
            tableView.deselectRow(at: indexPath, animated: true)
        case .howToCustomizeKeyboard:
            guard let rNC = UINavigationController.instantiateNavController(withRoot: ManagerTutorialViewController.self) else { break }
            rNC.root.model = Tutorials.HOW_TO_CUSTOMIZE_KEYBOARD
            rNC.root.fromSettings = true
            self.present(rNC.navController, animated: true)
            tableView.deselectRow(at: indexPath, animated: true)
        default:
            break
        }
    }
}
