//
//  PaymentGroupRoom.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 11/02/23.
//

import UIKit
import OlchaUI
public class PaymentGroupRoom: BaseTableCell {
    
    public var responder = PaymentGroupView()
    
    public var withBorder: Bool = false
    
    public override func setupViews() {
        container.addSubview(responder)
    }
    
    public override func autolayout() {
        responder.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    public override func configureViews() {
    }
    
    public func setup() {
        responder.withBorder = withBorder
    }
}
