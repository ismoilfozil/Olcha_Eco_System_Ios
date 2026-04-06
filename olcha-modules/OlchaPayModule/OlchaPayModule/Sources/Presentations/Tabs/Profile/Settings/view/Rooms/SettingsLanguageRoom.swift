//
//  SettingsLanguageRoom.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 06/03/23.
//

import UIKit
import OlchaUI
import OlchaUtils
public class SettingsLanguageRoom: BaseTableCell {

    private let biometricType = BiometricManager.shared.biometricType()
    
    private lazy var leftImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .globuse
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.style(.medium, 16)
        label.numberOfLines = 0
        label.textColor = .olchaTextBlack
        label.text = "app_language".localized()
        return label
    }()
    
    private lazy var valueLabel: UILabel = {
        let label = UILabel()
        label.style(.medium, 16)
        label.textColor = .olchaAccentColor
        return label
    }()
    
    public override func setupViews() {
        container.addSubview(leftImageView)
        container.addSubview(titleLabel)
        container.addSubview(valueLabel)
    }
    
    public override func autolayout() {
        leftImageView.snp.makeConstraints { make in
            make.width.height.equalTo(24)
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().inset(16)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(16)
            make.left.equalTo(leftImageView.snp.right).inset(-12)
        }
        
        valueLabel.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(16)
            make.top.bottom.equalToSuperview().inset(16)
        }
    }
    
    public func setup() {
        titleLabel.text = "app_language".localized()
        valueLabel.text = "lang".localized()
    }
}
