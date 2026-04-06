//
//  GuestCalculationButton.swift
//  OlchaMarketModule
//
//  Created by Elbek Khasanov on 30/01/24.
//

import UIKit
import OlchaUI

class GuestCalculationButton: BaseView {
    
    private let countLabel: Label = {
        let label = Label()
        
        label.backgroundColor = .hex("#D9D9D9").withAlphaComponent(0.6)
        label.settings.style(.semibold, 14)
        label.settings.textColor = .olchaWhite
        label.settings.textAlignment = .center
        
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        
        label.style(.semibold, 14)
        label.textColor = .olchaWhite
        
        return label
    }()
    
    private let confirmLabel: UILabel = {
        let label = UILabel()
        label.style(.medium, 16)
        label.textColor = .olchaWhite
        return label
    }()
    
    public let button = IButton()
    
    override func setupViews() {
        addSubview(countLabel)
        addSubview(priceLabel)
        addSubview(confirmLabel)
        addSubview(button)
    }
    
    override func autolayout() {
        let countLabelSize: CGFloat = 26
        countLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
            make.height.equalTo(countLabelSize)
            make.width.greaterThanOrEqualTo(countLabelSize)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.equalTo(countLabel.snp.right).inset(-8)
        }
        
        confirmLabel.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(16)
            make.top.bottom.equalToSuperview()
        }
        
        button.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        countLabel.round(countLabelSize/2)
    }
    
    override func configureViews() {
        backgroundColor = .olchaAccentColor
        round()
    }
    
    public func setup(products: [ProductModel]) {
        confirmLabel.text = "checkout_order".localized()
        
        countLabel.isHidden = products.isEmpty
        priceLabel.isHidden = products.isEmpty
        
        countLabel.text = products.count.string
        priceLabel.text = products.reduce(0, { $0 + ($1.total_price?.double ?? 0) }).string.price
    }
}
