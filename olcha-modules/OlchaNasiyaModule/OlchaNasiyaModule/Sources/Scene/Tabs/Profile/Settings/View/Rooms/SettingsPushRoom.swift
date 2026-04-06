//
//  SettingsPushRoom.swift
//  OlchaNasiyaModule
//
//  Created by Elbek Khasanov on 23/05/23.
//

import OlchaUtils
import UIKit
import OlchaUI
public class SettingsPushRoom: BaseTableCell {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.style(.medium, 14)
        label.numberOfLines = 0
        label.textColor = .olchaLightTextColornnnnnn
        return label
    }()
    
    private let switchButton: UISwitch = {
        let button = UISwitch()
        button.isOn = NasiyaGlobalDefaults.settings.pushNotificationsEnabled ?? false
        button.onTintColor = .olchaAccentColor
        return button
    }()
    
    public override func setupViews() {
        container.addSubview(titleLabel)
        container.addSubview(switchButton)
    }
    
    public override func autolayout() {
        titleLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(16)
            make.left.equalToSuperview().inset(16)
        }
        
        switchButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(16)
            make.left.equalTo(titleLabel.snp.right).inset(-12)
        }
    }
    
    public override func configureViews() {
        switchButton.addTarget(self, action: #selector (switchButtonObserver(_:)), for: .valueChanged)
    }
    
    @objc private func switchButtonObserver(_ sender: UISwitch) {
        NasiyaGlobalDefaults.settings.pushNotificationsEnabled = sender.isOn
    }
    
    public func setup() {
        titleLabel.text = "push_notification".localized()
    }
}
