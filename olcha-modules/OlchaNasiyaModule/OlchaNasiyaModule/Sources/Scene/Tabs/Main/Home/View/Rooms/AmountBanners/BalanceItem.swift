//
//  BalanceItem.swift
//  OlchaNasiyaModule
//
//  Created by Elbek Khasanov on 18/06/23.
//

import UIKit
import OlchaUI
import OlchaUtils
import OlchaBilling
import OlchaAuth

public class BalanceItem: BaseCollectionCell {
    
    public let responder = BalanceView()

    public override func setupViews() {
        container.addSubview(responder)
    }

    public override func autolayout() {
        responder.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.right.equalToSuperview()
        }
    }
    
    public func setup(with item: BillingCollectionItem) {
        responder.setup(amount: (item.balance?.amount?.string ?? "0"),
                        id: item.balance?.id?.int,
                        replenishable: item.is_replenishable,
                        currency: item.currency)
    }
}
