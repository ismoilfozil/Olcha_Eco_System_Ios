//
//  BalanceView.swift
//  OlchaBalance
//
//  Created by Elbek Khasanov on 11/05/23.
//

import UIKit
import OlchaUtils

public class BalanceView: BaseView {
    
    private let container = UIView()
    
    private let balanceTitle = UILabel()
    
    private let idLabel = UILabel()
    
    private let moneyStack = UIStackView()
    
    public let addIcon = IconButton()
    
    private let moneyTitle = UILabel()
    
    
    public override func setupViews() {
        addSubview(container)
        container.addSubview(balanceTitle)
        container.addSubview(idLabel)
        container.addSubview(moneyStack)
        moneyStack.addArrangedSubview(addIcon)
        moneyStack.addArrangedSubview(moneyTitle)
    }
        
    public override func autolayout() {
        container.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        balanceTitle.snp.makeConstraints { make in
            make.top.left.equalToSuperview().inset(16)
        }
        
        idLabel.snp.makeConstraints { make in
            make.top.right.equalToSuperview().inset(16)
        }
        
        moneyStack.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(16)
            make.centerX.equalToSuperview()
        }
        
        addIcon.snp.makeConstraints { make in
            make.width.height.equalTo(24)
        }
    }
    
    public override func configureViews() {
        container.round()
        container.backgroundColor = .olchaAccentColor
        
        balanceTitle.style(.medium, 14)
        balanceTitle.textColor = .olchaWhite
        balanceTitle.text = "Olcha Balans"
        
        idLabel.style(.medium, 14)
        idLabel.textColor = .white
        
        addIcon.setIcon(.plus_circle)
        
        moneyTitle.style(.bold, 24)
        moneyTitle.textColor = .white
        
        moneyStack.axis = .horizontal
        moneyStack.spacing = 8
    }
    
    ///replenishable - add icon state
    public func setup(amount: String?,
                      id: Int?,
                      replenishable: Bool? = true,
                      currency: String? = nil
    ) {
        idLabel.text = "ID: " + (id ?? 0).string
        moneyTitle.text = (amount?.originalPriceWithoutCurrency ?? "0") + " " + getCurrency(currency)
        addIcon.isHidden = !(replenishable ?? false)
    }

    private func getCurrency(_ currency: String?) -> String {
        currency ?? Texts.currency_alias
    }
    
}
