//
//  SettingsTableViewCell.swift
//  RightTyped
//
//  Created by Vitandrea Sorino on 08/07/23.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {
    
    public static var reuseID = "settingsTableViewCellID"
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet var rowButton: UIButton!
    
    private var cellModel: SettingsCellModel?
    
    private let switchComponent: UISwitch = {
        let sw = UISwitch()
        sw.onTintColor = .componentColor
        sw.translatesAutoresizingMaskIntoConstraints = false
        return sw
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    private func resetSwitchMode() {
        switchComponent.removeFromSuperview()
        containerView.addSubview(rowButton)
        rowButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20).isActive = true
        rowButton.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 5).isActive = true
        rowButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor).isActive = true
        rowButton.widthAnchor.constraint(equalToConstant: 11).isActive = true
        rowButton.heightAnchor.constraint(equalToConstant: 22).isActive = true
    }
    
    private func setSwitchMode(isOn: Bool?){
        if rowButton != nil{
            rowButton.removeFromSuperview()
        }
        guard !switchComponent.isDescendant(of: contentView) else { return }
        
        containerView.addSubview(switchComponent)
        switchComponent.isOn = isOn ?? false
        switchComponent.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20).isActive = true
        switchComponent.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 10).isActive = true
        switchComponent.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor).isActive = true
        switchComponent.widthAnchor.constraint(equalToConstant: 50).isActive = true
        switchComponent.addTarget(self, action: #selector(switchValueChanged), for: .valueChanged)
    }
    
    //MARK: Events
    @objc private func switchValueChanged(){
        cellModel?.action?(switchComponent.isOn)
    }
    
    //MARK: Configuration
    public func setModel(cellModel: SettingsCellModel){
        self.cellModel = cellModel
        self.titleLabel.set(text: cellModel.text, size: 18)
        
        switch cellModel.cellType{
        case .uiswitch:
            setSwitchMode(isOn: cellModel.status)
            self.selectionStyle = .none
        default:
            resetSwitchMode()
        }
    }
    
    public func setSwitch(_ enabled: Bool){
        switchComponent.setOn(enabled, animated: true)
    }
    
}
