//
//  SafetyPincodeRoom.swift
//  OlchaNasiyaModule
//
//  Created by Elbek Khasanov on 23/05/23.
//

import UIKit
import OlchaUtils
import OlchaPincode
import OlchaUI
public class SafetyPincodeRoom: BaseTableCell {

    private let biometricType = BiometricManager.shared.biometricType()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.style(.medium, 14)
        label.numberOfLines = 0
        label.textColor = .olchaLightTextColornnnnnn
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
        let isAllowed = BiometricManager.shared.checkBiometricPermission()
        
        if !isAllowed {
            permissionClickedObserver?()
        }
        PincodeGlobalDefaults.settings.biometricEnabled = sender.isOn
    }
    
}
