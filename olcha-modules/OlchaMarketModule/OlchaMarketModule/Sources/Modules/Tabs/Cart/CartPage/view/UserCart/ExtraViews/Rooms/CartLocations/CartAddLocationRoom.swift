//
//  CartAddLocationRoom.swift
//  OlchaMarketModule
//
//  Created by Elbek Khasanov on 05/02/24.
//

import UIKit
import OlchaUI
public class CartAddLocationRoom: BaseTableCell {
    private let addLocation: HorizontalButton = {
        let button = HorizontalButton()
        button.leftIconSize = 20
        button.rightIconSize = 20
        button.setup(leftIcon: .circle_add?.withColor(.olchaLightTextColornnnnnn ?? .gray))
        button.setup(rightIcon: .rightIcon?.withColor(.olchaLightTextColornnnnnn ?? .gray))
        button.settings.style(.medium, 16)
        button.settings.textAlignment = .left
        button.settings.textColor = .olchaTextBlack
        button.text = "add_address".localized()
        button.isUserInteractionEnabled = false
        return button
    }()
    
    public override func setupViews() {
        container.addSubview(addLocation)
    }
    
    public override func autolayout() {
        addLocation.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.bottom.equalToSuperview()
            make.height.equalTo(56)
        }
    }
    
    public func setup() {
        addLocation.text = "add_address".localized()
    }
}
