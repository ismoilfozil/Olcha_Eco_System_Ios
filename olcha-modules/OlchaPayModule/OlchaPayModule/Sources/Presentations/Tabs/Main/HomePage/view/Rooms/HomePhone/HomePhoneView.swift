//
//  HomePhoneRoom.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 02/02/23.
//

import UIKit
import OlchaUI
public class HomePhoneView: BaseView {
    
    lazy var phoneField: PayPhoneField = {
        let field = PayPhoneField()
//        field.type = .shortPhone
//        field.topHint = "pay_mobile_net".localized()
        return field
    }()
    
    public override func setupViews() {
        addSubview(phoneField)
    }
    
    public override func autolayout() {
        phoneField.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.right.equalToSuperview().inset(16)
        }
    }
    
    public override func languageUpdated() {
//        phoneField.topHint = "pay_mobile_net".localized()
//        phoneField.languageUpdated()
    }
    
}
