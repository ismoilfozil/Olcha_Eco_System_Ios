//
//  OrderPayRoom.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 25/10/22.
//

import UIKit
import OlchaUI
class OrderPayRoom: BaseTableCell {

    let payButton = OlchaButton()
    
    override func setupViews() {
        container.addSubview(payButton)
    }
    
    override func autolayout() {
        payButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
        }
    }
    
    override func configureViews() {
        payButton.setTitle("pay".localized())
    }
    
}
