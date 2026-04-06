//
//  SettingsLanguageRoom.swift
//  OlchaNasiyaModule
//
//  Created by Elbek Khasanov on 23/05/23.
//

import UIKit
import OlchaUI
import OlchaUtils
public class SettingsLanguageRoom: BaseTableCell {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.style(.medium, 14)
        label.numberOfLines = 0
        label.textColor = .olchaLightTextColornnnnnn
        return label
    }()
    
    private let valueLabel: UILabel = {
        let label = UILabel()
        label.style(.medium, 16)
        label.textColor = .olchaAccentColor
        return label
    }()
    
    public override func setupViews() {
        container.addSubview(titleLabel)
        container.addSubview(valueLabel)
    }
    
    public override func autolayout() {
        
        
        titleLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(16)
            make.left.equalToSuperview().inset(16)
        }
        
        valueLabel.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(16)
            make.top.bottom.equalToSuperview().inset(16)
        }
    }
    
    public func setup() {
        valueLabel.text = "lang".localized()
        titleLabel.text = "app_language".localized()
    }
}
