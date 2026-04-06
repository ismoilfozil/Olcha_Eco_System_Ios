//
//  AmountViewController.swift
//  OlchaInvestCore
//
//  Created by Akhrorkhuja on 10/06/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import UIKit
import OlchaUI
import OlchaPincode

public class AmountViewController: BaseViewController<BackNavigationBar> {

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.style(.semibold, 20)
        label.textColor = .olchaTextBlack
        label.textAlignment = .center
        return label
    }()
    
    private let amountLabel: UILabel = {
        let label = UILabel()
        label.style(.semibold, 32)
        label.textColor = .olchaLightTextColornnnnnn
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        return label
    }()
    
    private let amountLimitLabel: UILabel = {
        let label = UILabel()
        label.style(.medium, 14)
        label.textColor = .olchaLightTextColornnnnnn
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        return label
    }()
    
    private let continueButton: InvestOlchaButton = {
        let button = InvestOlchaButton()
        button.settings.setTitleColor(.lightGrayBackground, for: .normal)
        button.settings.setTitleColor(.olchaBlackNeutral, for: .disabled)
        button.settings.titleLabel?.font = .style(.semibold, 16)
        button.setButtonEnabled(false)
        button.round(10)
        return button
    }()
    
    private var tooltips: [AmountViewControllerTooltip] {
        return [
            .amount(in: amountLabel)
        ]
    }
    private let tooltipManager = TooltipManager()
    public let keyboard = KeyboardView()
    
    private var amount: String = "" {
        didSet {
            guard let model else { return }
            continueButton.setButtonEnabled(amount.double >= model.minimum_amount.orZero)
            amountLabel.text = "\(amount.priceWithoutCurrencyDouble) \(model.unwrappedCurrency)"
        }
    }
    
    private var model: InvestmentModel? {
        didSet {
            guard let model else { return }
            let format = "enter_amount_limit".localized(.olchaInvestCore)
            let minAmount = "\(model.minimum_amount.orZero.string.originalPriceWithoutCurrency) \(model.unwrappedCurrency)"
            amountLimitLabel.text = String(format: format, minAmount)
            amountLabel.text = "0 \(model.unwrappedCurrency)"
        }
    }
    
    public weak var coordinator: BasePackagesCoordinatorProtocol?
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tooltipManager.didViewAppear = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            guard let topView = self.topView else { return }
            self.tooltipManager.setup(tooltips: self.tooltips, darkView: topView)
        }
    }
    
    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        tooltipManager.destroy()
    }
    
    public override func setupViews() {
        container.addSubview(titleLabel)
        container.addSubview(amountLabel)
        container.addSubview(amountLimitLabel)
        container.addSubview(continueButton)
        container.addSubview(keyboard)
    }
    
    public override func autolayout() {
        titleLabel.snp.makeConstraints { make in
            make.top.lessThanOrEqualToSuperview().offset(40)
            make.left.right.equalToSuperview().inset(16)
        }
        amountLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(32)
            make.left.right.equalToSuperview().inset(16)
        }
        amountLimitLabel.snp.makeConstraints { make in
            make.top.equalTo(amountLabel.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(16)
        }
        continueButton.snp.makeConstraints { make in
            make.top.greaterThanOrEqualTo(amountLimitLabel.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(40)
        }
        keyboard.snp.makeConstraints { make in
            make.top.equalTo(continueButton.snp.bottom).offset(28)
            make.bottom.lessThanOrEqualToSuperview().inset(50)
            make.centerX.equalToSuperview()
        }
    }
    
    public override func configureViews() {
        languageUpdated()
    }

    public override func languageUpdated() {
        titleLabel.text = "enter_amount".localized()
        continueButton.setTitle("add_card_continue_button".localized(.olchaInvestCore))
    }
    
    public override func setupObservers() {
        keyboard.clickObserver = { [weak self] item in
            guard let self else { return }
            switch item {
            case .clear:
                keyboardClear()
            case .logout:
                break
            default:
                keyboardAdd(value: item.rawValue)
            }
        }
        coordinator?.termObserver.sink { [weak self] investment in
            self?.model = investment
        }.store(in: &bag)
        continueButton.clicked { [weak self] in
            guard let self else { return }
            coordinator?.investAmountObserver.send(amount.double)
            coordinator?.stopInvestSelection()
        }
    }
    
    private func keyboardClear() {
        guard !amount.isEmpty else { return }
        amount.removeLast()
    }
    
    private func keyboardAdd(value: Int) {
        guard (amount + value.string).double < 1_000_000_000_000 else { return }
        amount.append(value.string)
    }
    
}
