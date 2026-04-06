//
//  BalanceFillRoom.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 14/11/22.
//

import UIKit
import Combine
import OlchaUI
import OlchaUtils
class BalanceFillRoom: BaseTableCell {
    
    let fillButton = OlchaButton()
    private let hintTitle = UILabel()
    
    override func setupViews() {
        container.addSubview(fillButton)
        container.addSubview(hintTitle)
    }
    
    override func autolayout() {
        horizontalEdge = 16
        
        fillButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(8)
            make.width.greaterThanOrEqualTo(100)
            make.top.bottom.lessThanOrEqualToSuperview().inset(16)
        }
        
        hintTitle.snp.makeConstraints { make in
            make.right.equalTo(fillButton.snp.left).inset(-32)
            make.left.equalToSuperview().inset(8)
            make.top.bottom.lessThanOrEqualToSuperview().inset(16)
        }
        
    }
    
    override func configureViews() {
        container.round()
        container.backgroundColor = .lightGrayBackground
        hintTitle.numberOfLines = 0
        hintTitle.style(.medium, 14)
        hintTitle.textColor = .olchaLightTextColornnnnnn
        fillButton.setTitle("fill".localized())
    }
    
    func setup(observers: CartObservers?, selectedPayment: Payments?) {
        hintTitle.text = "not_enough_money".localized() + " " + (observers?.checkBalanceEnough(payment: selectedPayment).string.originalPrice ?? "")

    }
    
}

