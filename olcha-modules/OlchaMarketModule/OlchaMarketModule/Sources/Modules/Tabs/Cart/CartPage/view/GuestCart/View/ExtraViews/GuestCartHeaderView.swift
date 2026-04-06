//
//  GuestCartHeaderView.swift
//  OlchaMarketModule
//
//  Created by Elbek Khasanov on 30/01/24.
//

import UIKit
import OlchaUI
class GuestCartHeaderView: BaseView {
    
    let cancelButton: HorizontalButton = {
        let button = HorizontalButton()
        button.setup(leftIcon: .x_cancel)
        button.leftIconSize = 24
        button.settings.style(.medium, 14)
        button.settings.textColor = .olchaLightTextColornnnnnn
        
        return button
    }()
    
    let selectButton: HorizontalButton = {
        let button = HorizontalButton()
        button.setup(rightIcon: .unchecked)
        button.rightIconSize = 24
        button.settings.style(.medium, 14)
        button.settings.textColor = .olchaLightTextColornnnnnn
        
        return button
    }()
    
    let separator = Divide()
    
    var isSelected: Bool = false {
        didSet {
            selectButton.setup(rightIcon: (isSelected ? .checked : .unchecked))
        }
    }
    
    override func setupViews() {
        addSubview(cancelButton)
        addSubview(selectButton)
        addSubview(separator)
    }
    
    override func autolayout() {
        cancelButton.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
        }
        
        selectButton.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
        }
        
        separator.snp.makeConstraints { make in
            make.top.equalTo(selectButton.snp.bottom).inset(-16)
            make.left.right.equalToSuperview().inset(16)
        }
    }
    
    func setup() {
        cancelButton.text = "selected".localized()
        selectButton.text = "all".localized()
    }
}
