//
//  SettingsPincodeRoom.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 05/03/23.
//

import UIKit
import OlchaUtils
import OlchaPincode
import OlchaUI
public class SettingsPincodeRoom: BaseTableCell {

    private let biometricType = BiometricManager.shared.biometricType()
    
    private lazy var leftImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = (biometricType == .face) ? .face_id : .touch_id
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.style(.medium, 16)
        label.numberOfLines = 0
        label.textColor = .olchaTextBlack
        label.text = ((biometricType == .face) ? "face_id_title" : "touch_id_title").localized()
        return label
    }()
    
    private lazy var switchButton: UISwitch = {
        let button = UISwitch()
        button.isOn = PincodeGlobalDefaults.settings.biometricEnabled ?? false
        button.onTintColor = .olchaAccentColor
        return button
    }()
    
    var permissionClickedObserver: (() -> Void)?
    
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
        let isAllowed = BiometricManager.shared.checkBiometricPermission()
        
        if !isAllowed {
            permissionClickedObserver?()
        }
        PincodeGlobalDefaults.settings.biometricEnabled = sender.isOn
    }
    
    public func setup() {
        titleLabel.text = ((biometricType == .face) ? "face_id_title" : "touch_id_title").localized()
    }
    
}
