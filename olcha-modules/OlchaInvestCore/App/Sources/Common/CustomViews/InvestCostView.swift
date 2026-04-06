//
//  InvestCostView.swift
//  OlchaInvestCore
//
//  Created by Akhrorkhuja on 25/05/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import UIKit
import OlchaUI

public class InvestCostView: BaseView {
    
    private let topStack: UIStackView = {
        let stack = UIStackView()
        stack.distribution = .equalSpacing
        return stack
    }()
    
    private let investLabel: UILabel = {
        let label = UILabel()
        label.style(.medium, 12)
        label.textColor = .olchaBlackNeutral
        return label
    }()
    
    private let profitLabel: UILabel = {
        let label = UILabel()
        label.style(.medium, 12)
        label.textColor = .olchaBlackNeutral
        return label
    }()
    
    private let bottomStack: UIStackView = {
        let stack = UIStackView()
        stack.distribution = .equalSpacing
        return stack
    }()
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let investSumLabel: UILabel = {
        let label = UILabel()
        label.style(.semibold, 18)
        label.textColor = .olchaBlackNeutral
        return label
    }()
    
    private let profitSumLabel: UILabel = {
        let label = UILabel()
        label.style(.semibold, 18)
        label.textColor = .olchaGreen
        return label
    }()
    
    private var investAmount: Double = 0.0
    private var profitAmount: Double = 0.0
    private var currency: String? {
        didSet {
            guard let currency else { return }
            investSumLabel.text = "\(investAmount.string.priceWithoutCurrencyDouble) \(currency)"
            profitSumLabel.text = "\(profitAmount.string.priceWithoutCurrencyDouble) \(currency)"
        }
    }
    
    public override func setupViews() {
        self.addSubview(topStack)
        self.addSubview(bottomStack)
        topStack.addArrangedSubview(investLabel)
        topStack.addArrangedSubview(profitLabel)
        bottomStack.addArrangedSubview(investSumLabel)
        bottomStack.addArrangedSubview(iconImageView)
        bottomStack.addArrangedSubview(profitSumLabel)
    }
    
    public override func autolayout() {
        topStack.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(10)
            make.left.right.equalToSuperview().inset(16)
        }
        bottomStack.snp.makeConstraints { make in
            make.top.equalTo(topStack.snp.bottom).offset(4)
            make.left.right.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(10)
        }
        iconImageView.snp.makeConstraints { make in
            make.width.equalTo(24)
        }
    }
    
    public override func configureViews() {
        self.backgroundColor = .lightGrayBackground
        investSumLabel.text = "\(investAmount.string.priceWithoutCurrencyDouble) \(currency.unwrap)"
        profitSumLabel.text = "\(profitAmount.string.priceWithoutCurrencyDouble) \(currency.unwrap)"
        iconImageView.image = .arrowGrowth
        languageUpdated()
    }
    
    public func setCurrency(_ currency: String) {
        self.currency = currency
    }
    
    public func setInvestAmount(_ amount: String) {
        investAmount = amount.double
        investSumLabel.text = "\(amount.priceWithoutCurrencyDouble) \(currency.unwrap)"
    }
    
    public func setProfitAmount(_ amount: String) {
        profitAmount = amount.double
        profitSumLabel.text = "\(amount.priceWithoutCurrencyDouble) \(currency.unwrap)"
    }
    
    public override func languageUpdated() {
        investLabel.text = "cost_view_invest".localized(.olchaInvestCore)
        profitLabel.text = "cost_view_profit".localized(.olchaInvestCore)
    }
    
}
