//
//  CartCostRoom.swift
//  OlchaMarketModule
//
//  Created by Elbek Khasanov on 02/02/24.
//

import UIKit
import OlchaUI

public class CartCostRoom: BaseTableCell {

    public let responder = CartCostView()

    public override func setupViews() {
        container.addSubview(responder)
    }
    
    public override func autolayout() {
        responder.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(24)
            make.left.right.equalToSuperview()
        }
    }
    
    public override func configureViews() {
        container.backgroundColor = CartStyle.whiteColor
        backgroundColor = CartStyle.backgroundColor
    }
}
