//
//  LimitRoom.swift
//  OlchaNasiyaModule
//
//  Created by Elbek Khasanov on 18/06/23.
//

import UIKit
import OlchaUI
import OlchaAuth
public class LimitRoom: BaseCollectionCell {
    
    public let responder = LimitView()
    
    public override func setupViews() {
        container.addSubview(responder)
    }
    
    public override func autolayout() {
        responder.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.right.equalToSuperview()
        }
    }
    
    public func setup(with data: InstallmentLimitBalanceModel?) {
        responder.setup(amount: (data?.amount ?? 0).string, id: data?.id)
    }
}
