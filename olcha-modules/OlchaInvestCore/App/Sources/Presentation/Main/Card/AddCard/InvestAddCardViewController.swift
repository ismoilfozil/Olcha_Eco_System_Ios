//
//  InvestAddCardViewController.swift
//  OlchaInvestCore
//
//  Created by Akhrorkhuja on 23/05/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import UIKit
import OlchaUI

public class InvestAddCardViewController: BaseViewController<TitleNavigationBar> {
    
    private lazy var scrollView: IScrollView = {
        let scrollView = IScrollView()
        scrollView.horizontalEdge()
        scrollView.container.spacing = 16
        return scrollView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.style(.semibold, 20)
        label.textColor = .olchaTextBlack
        return label
    }()
    
    private let cardNumberTextField: InvestTField = {
        let textfield = InvestTField()
        textfield.placeholder = "0000 0000 0000 0000"
        textfield.type = .cardNumber
        return textfield
    }()
    
    private let cardExpireTextField: InvestTField = {
        let textfield = InvestTField()
        textfield.placeholder = "мм/гг"
        textfield.type = .cardExpire
        return textfield
    }()
    
    private let phoneTextField: InvestTField = {
        let textfield = InvestTField()
        textfield.type = .shortPhone
        return textfield
    }()
    
    private let codeTextField: InvestTField = {
        let textfield = InvestTField()
        textfield.placeholder = "_ _ _ _ _"
        textfield.isHidden = true
        return textfield
    }()
    
    private let sendCodeButton: InvestOlchaButton = {
        let button = InvestOlchaButton()
        button.setButtonEnabled(false)
        button.settings.setTitleColor(.olchaBlackNeutral, for: .disabled)
        button.settings.setTitleColor(.lightGrayBackground, for: .normal)
        button.settings.titleLabel?.font = .style(.semibold, 16)
        button.round(10)
        return button
    }()
    
    private let continueButton: InvestOlchaButton = {
        let button = InvestOlchaButton()
        button.setButtonEnabled(false)
        button.settings.setTitleColor(.olchaBlackNeutral, for: .disabled)
        button.settings.setTitleColor(.lightGrayBackground, for: .normal)
        button.settings.titleLabel?.font = .style(.semibold, 16)
        button.isHidden = true
        button.round(10)
        return button
    }()
    
    public let viewModel: InvestCardViewModel
    public weak var coordinator: ProfitCoordinatorProtocol?
    public weak var investorCoordinator: InvestCoordinatorProtocol?
    
    public init(viewModel: InvestCardViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func setupViews() {
        container.addSubview(scrollView)
        scrollView.addArrangedSubview(titleLabel)
        scrollView.addArrangedSubview(cardNumberTextField)
        scrollView.addArrangedSubview(cardExpireTextField)
        scrollView.addArrangedSubview(phoneTextField)
        scrollView.addArrangedSubview(codeTextField)
        scrollView.addArrangedSubview(sendCodeButton)
        scrollView.addArrangedSubview(continueButton)
    }
    
    public override func autolayout() {
        scrollView.container.setCustomSpacing(20, after: titleLabel)
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    public override func configureViews() {
        languageUpdated()
    }
    
    public override func languageUpdated() {
        titleLabel.text = "add_card_title".localized(.olchaInvestCore)
        sendCodeButton.setTitle("add_card_code_button".localized(.olchaInvestCore))
        continueButton.setTitle("add_card_continue_button".localized(.olchaInvestCore))
        cardNumberTextField.topHint = "add_card_number".localized(.olchaInvestCore)
        cardExpireTextField.topHint = "add_card_expire_date".localized(.olchaInvestCore)
        phoneTextField.topHint = "phone_number".localized()
        codeTextField.topHint = "add_card_code".localized(.olchaInvestCore)
    }
    
    public override func setupObservers() {
        handle(viewModel.$hasSentCode, showLoader: true, success: { [weak self] response in
            guard let self, let response else { return }
            let (hasSentCode, errorText) = response
            cardNumberTextField.bottomHint = errorText ?? ""
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.cardNumberTextField.bottomHint = ""
            }
            codeTextField.isHidden = !hasSentCode
            continueButton.isHidden = !hasSentCode
            sendCodeButton.isHidden = hasSentCode
        })
        
        viewModel.$isCardExists.sink { [weak self] exists in
            guard let self, exists else { return }
            self.popToInvestCardViewController()
        }.store(in: &bag)

        handle(viewModel.$hasConfirmedCode, showLoader: true, success: { [weak self] hasConfirmedCode in
            guard let self, let hasConfirmedCode, hasConfirmedCode else { return }
            self.popToInvestCardViewController()
        })
        
        sendCodeButton.clicked { [weak self] in
            guard let self else { return }
            let pan = cardNumberTextField.getValue()
            let expiryDate = cardExpireTextField.getValue()
            let phone = "998\(phoneTextField.getValue())"
            viewModel.sendOtp(model: CardSendOtpRequest(pan: pan, expiry: expiryDate, phone: phone))
        }
        continueButton.clicked { [weak self] in
            guard let self else { return }
            let pan = self.cardNumberTextField.getValue()
            let expiryDate = self.cardExpireTextField.getValue()
            let phone = self.phoneTextField.getValue()
            let code = self.codeTextField.getCardNumber()
            let requestModel = CardConfirmOtpRequest(pan: pan, expiry: expiryDate, phone: phone, code: code)
            self.viewModel.confirmOtp(model: requestModel)
        }
        observeTextFields(fields: cardNumberTextField, cardExpireTextField, phoneTextField) { [weak self] in
            self?.updateButtonState()
        }
        codeTextField.observeText { [weak self] in
            let codeText = self?.codeTextField.getValue() ?? ""
            self?.continueButton.setButtonEnabled(!codeText.isEmpty)
        }
    }
    
    private func updateButtonState() {
        let isFieldsValid = [cardNumberTextField, cardExpireTextField, phoneTextField].map({ $0.isValidated() }).allSatisfy({ $0 == true })
        sendCodeButton.isEnabled = isFieldsValid
    }
    
    public func popToInvestCardViewController() {
        coordinator?.popToInvestCardViewController()
        investorCoordinator?.popToInvestCardViewController()
    }
    
}
