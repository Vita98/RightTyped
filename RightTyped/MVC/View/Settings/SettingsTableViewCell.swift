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
    @IBOutlet weak var rowButton: UIButton!
    
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
        self.titleLabel.text = cellModel.text
        
        switch cellModel.type{
        case .App,.Keyboard:
            setSwitchMode(isOn: cellModel.status)
            self.selectionStyle = .none
        default:
            break
        }
    }
    
    public func setSwitch(_ enabled: Bool){
        switchComponent.setOn(enabled, animated: true)
    }
    
}
