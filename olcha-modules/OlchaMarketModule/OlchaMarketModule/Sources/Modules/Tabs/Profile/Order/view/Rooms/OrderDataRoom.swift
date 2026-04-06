//
//  OrderDataRoom.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 21/10/22.
//

import UIKit
import OlchaUI
class OrderDataRoom: BaseTableCell {

    private let containerStack = UIStackView()
    private let titleLabel = UILabel()
    private let valueLabel = UILabel()
    private let topSeparator = Divide()
    private let bottomSeparator = Divide()
    private let descriptionView = OrderProductViewDescriptionView()
    override func setupViews() {
        container.addSubview(topSeparator)
        container.addSubview(containerStack)
        container.addSubview(bottomSeparator)
        containerStack.addArrangedSubview(titleLabel)
        containerStack.addArrangedSubview(valueLabel)
    }
    
    override func autolayout() {
        topSeparator.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.equalToSuperview()
        }
        
        bottomSeparator.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.left.right.equalToSuperview().inset(16)
        }
        
        containerStack.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.bottom.equalToSuperview().inset(12)
        }
    }
    
    override func configureViews() {
        titleLabel.style(.medium, 14)
        titleLabel.textColor = .olchaLightTextColornnnnnn
        titleLabel.numberOfLines = 0
        
        valueLabel.style(.medium, 14)
        valueLabel.textColor = .olchaTextBlack
        valueLabel.numberOfLines = 0
        valueLabel.textAlignment = .right
        
        containerStack.axis = .horizontal
        containerStack.distribution = .fillEqually
        containerStack.alignment = .firstBaseline
        
        bottomSeparator.isHidden = true
    }
    
    func setup(with data: OrderDataModel) {
        titleLabel.text = data.title
        valueLabel.style(.medium, 14)
        switch data {
        case .type(let string):
            valueLabel.text = string
        case .date(let string):
            valueLabel.text = string
        case .price(let string):
            valueLabel.style(.semibold, 14)
            valueLabel.text = string
        case .contact(let string):
            valueLabel.text = string
        case .phone(let string):
            valueLabel.text = string
        case .location(let string):
            valueLabel.text = string
        }
    }
}
