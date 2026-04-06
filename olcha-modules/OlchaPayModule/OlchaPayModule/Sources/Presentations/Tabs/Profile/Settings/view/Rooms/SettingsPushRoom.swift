//
//  SettingsPushRoom.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 06/03/23.
//
import OlchaUtils
import UIKit
import OlchaUI
public class SettingsPushRoom: BaseTableCell {

    private let biometricType = BiometricManager.shared.biometricType()
    
    private lazy var leftImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .notifications
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.style(.medium, 16)
        label.numberOfLines = 0
        label.textColor = .olchaTextBlack
        label.text = "push_notification".localized()
        return label
    }()
    
    private lazy var switchButton: UISwitch = {
        let button = UISwitch()
        button.isOn = PayGlobalDefaults.settings.pushNotificationsEnabled ?? false
        button.onTintColor = .olchaAccentColor
        return button
    }()
    
    public override func setupViews() {
        container.addSubview(leftImageView)
        container.addSubview(titleLabel)
        container.addSubview(switchButton)
    }
    
    public override func autolayout() {
        leftImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().inset(16)
            make.width.height.equalTo(24)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(16)
            make.left.equalTo(leftImageView.snp.right).inset(-12)
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
        PayGlobalDefaults.settings.pushNotificationsEnabled = sender.isOn
    }
    
    public func setup() {
        titleLabel.text = "push_notification".localized()
    }
}
