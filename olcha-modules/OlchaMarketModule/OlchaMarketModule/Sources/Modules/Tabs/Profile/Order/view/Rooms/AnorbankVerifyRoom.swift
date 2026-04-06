//
//  AnorbankVerifyRoom.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 15/11/22.
//

import UIKit
import OlchaUI
class AnorbankVerifyRoom: BaseTableCell {

    let verifyButton = OlchaButton()
    
    override func setupViews() {
        container.addSubview(verifyButton)
    }
    
    override func autolayout() {
        verifyButton.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(16)
            make.top.bottom.equalToSuperview().inset(8)
        }
    }
    
    override func configureViews() {
        verifyButton.settings.titleLabel?.style(.medium, 12)
        verifyButton.setTitle("anorbank_verify".localized())
    }
    
}
