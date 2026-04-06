//
//  InvestProfitView.swift
//  OlchaInvestCore
//
//  Created by Akhrorkhuja on 29/05/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import UIKit
import OlchaUI

public class InvestProfitView: BaseView {
    
    public let contentStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 0
        return stack
    }()
    
    private let topStack: UIStackView = {
        let stack = UIStackView()
        stack.distribution = .equalSpacing
        return stack
    }()
    
    private let totalLabel: UILabel = {
        let label = UILabel()
        label.style(.semibold, 16)
        label.textColor = .olchaLightTextColornnnnnn
        label.text = "\t"
        label.textAlignment = .center
        return label
    }()
    
    private let profitPlusLabel: UILabel = {
        let label = UILabel()
        label.style(.medium, 12)
        label.textColor = .olchaLightTextColornnnnnn
        label.text = "\t"
        return label
    }()
    private let profitPlusValue: UILabel = {
        let label = UILabel()
        label.style(.semibold, 18)
        label.textColor = .olchaTextBlack
        label.text = "\t"
        return label
    }()
    
    private let profitMinusLabel: UILabel = {
        let label = UILabel()
        label.style(.medium, 12)
        label.textColor = .olchaLightTextColornnnnnn
        label.text = "\t"
        return label
    }()
    private let profitMinusValue: UILabel = {
        let label = UILabel()
        label.style(.semibold, 18)
        label.textColor = .olchaTextBlack
        label.text = "\t"
        return label
    }()
    
    private let bottomStack: UIStackView = {
        let stack = UIStackView()
        stack.distribution = .equalSpacing
        return stack
    }()
    
    private let totalSumLabel: UILabel = {
        let label = UILabel()
        label.style(.bold, 24)
        label.textColor = .olchaLightGreen
        label.text = "\t"
        label.textAlignment = .center
        return label
    }()
    
    public let withdrawalButton: LeftIconButton = {
        let button = LeftIconButton()
        button.backgroundColor = .olchaLightNeutralGray
        button.round(8.0)
        button.enableContainer()
        button.titleLabel.style(.medium, 14.0)
        button.setIcon(.cornerDownRightAlt, iconSize: 16.0)
        return button
    }()
    
    private(set) var totalAmount: Double = 0.0
    private(set) var profitOutAmount: Double = 0.0
    private(set) var profitInsideAmount: Double = 0.0
    private(set) var currency: String? {
        didSet {
            guard let currency else { return }
            totalSumLabel.text = "\(totalAmount.string.priceWithoutCurrencyDouble) \(currency)"
            profitPlusValue.text = "\(profitOutAmount.string.priceWithoutCurrencyDouble) \(currency)"
            profitMinusValue.text = "\(profitInsideAmount.string.priceWithoutCurrencyDouble) \(currency)"
        }
    }
    
    public override func setupViews() {
        self.addSubview(contentStack)
        contentStack.addArrangedSubview(totalLabel)
        contentStack.addArrangedSubview(totalSumLabel)
        contentStack.addArrangedSubview(topStack)
        contentStack.addArrangedSubview(bottomStack)
//        self.addSubview(topStack)
//        self.addSubview(bottomStack)
        topStack.addArrangedSubview(profitPlusLabel)
        topStack.addArrangedSubview(profitMinusLabel)
        bottomStack.addArrangedSubview(profitPlusValue)
        bottomStack.addArrangedSubview(profitMinusValue)
        self.addSubview(withdrawalButton)
    }
    
    public override func autolayout() {
        contentStack.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview().inset(16)
        }
//        topStack.snp.makeConstraints { make in
//            make.top.left.right.equalToSuperview().inset(16)
//        }
//        bottomStack.snp.makeConstraints { make in
//            make.top.equalTo(topStack.snp.bottom).offset(4)
//            make.left.right.equalToSuperview().inset(16)
//        }
        withdrawalButton.snp.makeConstraints { make in
            make.top.equalTo(contentStack.snp.bottom).offset(16)
            make.left.right.bottom.equalToSuperview().inset(16)
        }
    }
    
    public override func configureViews() {
        self.backgroundColor = .lightGrayBackground
        self.round(14.0)
//        totalSumLabel.text = "0 сум"
//        profitSumLabel.text = "0 сум"
        languageUpdated()
        contentStack.setCustomSpacing(16, after: totalSumLabel)
    }
    
    public func setCurrency(_ currency: String) {
        self.currency = currency
    }
    
    public func setTotalAmount(_ amount: String) {
        totalAmount = amount.double
        totalSumLabel.text = "\(amount.originalPriceWithoutCurrency) \(currency.unwrap)"
    }
    
    public func setProfitOut(_ amount: String) {
        profitOutAmount = amount.double
        profitPlusValue.text = "\(amount.originalPriceWithoutCurrency) \(currency.unwrap)"
    }
    
    public func setProfitInside(_ amount: String) {
        profitInsideAmount = amount.double
        profitMinusValue.text = "\(amount.originalPriceWithoutCurrency) \(currency.unwrap)"
    }
    
    public func clicked(completion: (() -> Void)?) {
        withdrawalButton.settings.clicked { completion?() }
    }
    
    public override func languageUpdated() {
        totalLabel.text = "profit_total_sum".localized(.olchaInvestCore)
        withdrawalButton.setTitle("profit_withdraw".localized(.olchaInvestCore))
        
        profitPlusLabel.text = "profit_out".localized(.olchaInvestCore)
        profitMinusLabel.text = "profit_inside".localized(.olchaInvestCore)
    }
    
}
