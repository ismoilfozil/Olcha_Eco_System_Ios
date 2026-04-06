//
//  BillingVerificationCardItem.swift
//  OlchaBilling
//
//  Created by Elbek Khasanov on 17/08/23.
//

import UIKit
import OlchaUI
import OlchaBankCards

public class BillingVerificationCardRoom: BaseTableCell {
    
    public var responder = BillingCardView()
    
    public override func setupViews() {
        container.addSubview(responder)
    }
    
    public override func autolayout() {
        responder.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.bottom.equalToSuperview().inset(8)
        }
    }
    
    public override func configureViews() {
        makeSkeleton(views: [
            responder.container,
            responder.amountTitle,
            responder.cardLogo,
            responder.nameTitle,
            responder.menuButton,
            responder.cardNumberTitle,
            responder.expireTitle
        ])
    }
    
    public func reset() {
        responder.reset()
    }
    
    public func setup(with data: BillingBankCard, currency: String? = nil, isSelected: Bool = false) {
        responder.setup(with: data, currency: currency)
        responder.checkSelection(isSelected: isSelected)
    }
    
    public func setHorizontalContentInsets(inset: CGFloat) {
        responder.snp.updateConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(inset)
        }
    }
    
}
