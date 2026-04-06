//
//  InvestViewController.swift
//  OlchaInvestCore
//
//  Created by Akhrorkhuja on 25/05/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import UIKit
import OlchaUI
import OlchaUtils

public class InvestViewController: BaseViewController<TitleNavigationBar> {
    
    private lazy var scrollView: IScrollView = {
        let scrollView = IScrollView()
        scrollView.horizontalEdge()
        scrollView.container.spacing = 20
        scrollView.settings.showsVerticalScrollIndicator = false
        scrollView.settings.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 100, right: 0)
        return scrollView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.style(.semibold, 20)
        label.textColor = .olchaTextBlack
        return label
    }()
    
    private let contractNameTextField: InvestTField = {
        let textfield = InvestTField()
        return textfield
    }()
    
    private let packageTextField: InvestTField = {
        let textfield = InvestTField()
        textfield.rightImage = .angleRight
        textfield.enableButton = true
        textfield.setDisabled()
        return textfield
    }()
    
    private let textfieldStack: UIStackView = {
        let stack = UIStackView()
        stack.alignment = .firstBaseline
        stack.spacing = 16
        stack.distribution = .fillEqually
        return stack
    }()
    
    private let termTextField: InvestTField = {
        let textfield = InvestTField()
        textfield.rightImage = .angleRight
        let termString = String(format: "term_value".localized(.olchaInvestCore), "0")
        textfield.placeholder = termString
        textfield.enableButton = true
        textfield.setDisabled()
        return textfield
    }()
    
    private let riskTextField: InvestTField = {
        let textfield = InvestTField()
        textfield.placeholder = "0%"
        textfield.type = .default
        textfield.setDisabled()
        textfield.setDisabledBackground()
        return textfield
    }()
    
    private let sumTextField: InvestTField = {
        let textfield = InvestTField()
        textfield.type = .amount
        textfield.setFieldDisabled()
        textfield.placeholder = "0"
        return textfield
    }()
    
    private let investButton: InvestOlchaButton = {
        let button = InvestOlchaButton()
        button.settings.setTitleColor(.olchaBlackNeutral, for: .disabled)
        button.settings.setTitleColor(.lightGrayBackground, for: .normal)
        button.settings.titleLabel?.font = .style(.semibold, 16)
        button.settings.backgroundColor = .olchaPrimaryColor
        button.round(10)
        return button
    }()
    
    private let warningView = InvestWarningView()
    
    private let costView = InvestCostView()
    
    private var tooltips: [InvestViewControllerTooltip] {
        return [
            .name(in: contractNameTextField),
            .package(in: packageTextField),
            .term(in: termTextField),
            .percent(in: riskTextField),
            .amount(in: sumTextField),
            .preview(in: costView)
        ]
    }
    
    private lazy var keyboardManager = KeyboardManager()
    private let tooltipManager = TooltipManager()
    public var input: Input
    public var output: Output
    public let viewModel: InvestViewModel
    public var coordinator: InvestCoordinatorProtocol?
    
    public init(
        input: Input = .init(),
        output: Output = .init(),
        viewModel: InvestViewModel
    ) {
        self.input = input
        self.output = output
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tooltipManager.didViewAppear = true
        guard let topView = topView else { return }
        tooltipManager.setup(tooltips: tooltips, darkView: topView)
        keyboardManager.startObservingKeyboard()
        keyboardManager.keyboardWillShowObserver = keyboardWillShowObserver
        keyboardManager.keyboardWillHideObserver = keyboardWillHideObserver
    }
    
    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        keyboardManager.stopObservingKeyboard()
    }
    
    public override func setupViews() {
        container.addSubview(scrollView)
        scrollView.addArrangedSubview(titleLabel)
        scrollView.addArrangedSubview(contractNameTextField)
        scrollView.addArrangedSubview(packageTextField)
        scrollView.addArrangedSubview(textfieldStack)
        textfieldStack.addArrangedSubview(termTextField)
        textfieldStack.addArrangedSubview(riskTextField)
        scrollView.addArrangedSubview(sumTextField)
        scrollView.addArrangedSubview(investButton)
        scrollView.addArrangedSubview(warningView)
        container.addSubview(costView)
    }
    
    public override func autolayout() {
        scrollView.container.setCustomSpacing(16, after: titleLabel)
        scrollView.container.setCustomSpacing(24, after: sumTextField)
        scrollView.container.setCustomSpacing(16, after: investButton)
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        costView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
        }
    }
    
    public override func configureViews() {
        languageUpdated()
        updateInvestButton()
    }
    
    public override func languageUpdated() {
        navigationBar.setTitle("home_invest".localized(.olchaInvestCore))
        titleLabel.text = "invest_question".localized(.olchaInvestCore)
        investButton.setTitle("home_invest".localized(.olchaInvestCore))
        warningView.setWarningText("invest_warning".localized(.olchaInvestCore))
        contractNameTextField.topHint = "invest_contract_name_hint".localized(.olchaInvestCore)
        contractNameTextField.placeholder = "invest_contract_name".localized(.olchaInvestCore)
        packageTextField.placeholder = "select".localized(.olchaInvestCore)
        packageTextField.topHint = "package".localized(.olchaInvestCore)
        termTextField.topHint = "contract_term".localized(.olchaInvestCore)
        riskTextField.topHint = "contract_percent".localized(.olchaInvestCore)
        sumTextField.topHint = "invest_amount".localized(.olchaInvestCore)
        costView.languageUpdated()
    }
    
    public override func setupObservers() {
        contractNameTextField.observeText { [weak self] in
            guard let self else { return }
            updateInvestButton()
        }
        packageTextField.button.clicked { [weak self] in
            self?.pushSelectPackageViewController()
        }
        termTextField.button.clicked { [weak self] in
            guard let self, let packageId = input.packageId else { return }
            pushSelectTermViewController(packageId: packageId)
        }
        sumTextField.observeText { [weak self] in
            guard let self, let model = input.investment else { return }
            let amount = sumTextField.getValue().isEmpty ? "0" : sumTextField.getValue()
            costView.setCurrency(model.unwrappedCurrency)
            costView.setInvestAmount(amount)
            let term = Double(model.term.orZero)
            let lowestTerm = Double(model.lowest_term.orZero)
            let profit = amount.double * (model.percent.orZero.double / 100) * (term / lowestTerm)
            costView.setProfitAmount(profit.string)
            updateInvestButton()
        }
        handle(viewModel.$isContractCreated, showLoader: true, success: { [weak self] data in
            guard let self, let contractId = data?.id, let reflection = data?.billing_reflection else { return }
            coordinator?.pushBillingPaymentViewController(
                contractId: contractId, reflection: reflection,
                values: (data?.min_invest?.int, data?.max_invest?.int, data?.start_invest?.int)
            )
        })
        investButton.clicked { [weak self] in
            guard let self else { return }
            let contractName = contractNameTextField.getValue().trimmingCharacters(in: .whitespaces)
            let investorId = InvestGlobalDefaults.account.investorId
            let investmentId = input.investment?.id
            let startInvest = sumTextField.getValue().double
            guard sumTextField.isValidated(), let investorId, let investmentId else { return }
            
            viewModel.storeContract(model: AddContractRequest(
                currency: .uzs,
                investment_id: investmentId,
                investor_id: investorId,
                start_invest: startInvest,
                contract_name: contractName)
            )
        }
        coordinator?.termObserver
            .compactMap({ $0 })
            .sink { [weak self] investment in
                guard let self else { return }
                input.investment = investment
                sumTextField.setFieldEnabled()
                packageTextField.text = investment.name.unwrap
                let termString = String(format: "term_value".localized(.olchaInvestCore), investment.term.orZero.string)
                termTextField.text = termString
                riskTextField.text = "\(investment.percent.orZero)%"
                updateSumFieldRule(investment.minimum_amount)
            }.store(in: &bag)
        coordinator?.packageIdObserver.sink { [weak self] packageId in
            guard let self else { return }
            input.packageId = packageId
        }.store(in: &bag)
        setupInvestAmountObserver()
    }
}

public extension InvestViewController {
    func updateInvestButton() {
        let contractName = !contractNameTextField.getValue().trimmingCharacters(in: .whitespaces).isEmpty
        let investorId = InvestGlobalDefaults.account.investorId
        let investmentId = input.investment?.id
        let isValidated = contractName && sumTextField.isValidated() && investorId != nil && investmentId != nil
        investButton.setButtonEnabled(isValidated)
    }
    
    func pushSelectPackageViewController() {
        coordinator?.pushSelectPackageViewController()
    }
    
    func pushSelectTermViewController(packageId: Int) {
        coordinator?.pushSelectTermViewController(packageId: packageId, childPackageId: input.investment?.id)
    }
}

private extension InvestViewController {
    func keyboardWillShowObserver(height: CGFloat, timeInterval: TimeInterval) {
        scrollView.settings.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: height, right: 0)
        costView.snp.remakeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalTo(self.view.snp.bottom).inset(height)
        }
        UIView.animate(withDuration: timeInterval) {
            self.view.layoutIfNeeded()
        }
    }
    
    func keyboardWillHideObserver() {
        scrollView.settings.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 100, right: 0)
        costView.snp.remakeConstraints { make in
            make.left.right.bottom.equalToSuperview()
        }
        UIView.animate(withDuration: 0.4) {
            self.view.layoutIfNeeded()
        }
    }
    
    func updateSumFieldRule(_ minAmount: Double?) {
        let ruleMinAmount = Double(minAmount.orZero)
        sumTextField.rules.removeAll()
        sumTextField.addRule(TextFieldRules.investAmountRule(min: ruleMinAmount))
    }
    
    func setupInvestAmountObserver() {
        coordinator?.investAmountObserver.sink { [weak self] amount in
            guard let self, !amount.isZero else { return }
            sumTextField.text = amount.string.priceWithoutCurrencyDouble
            sumTextField.settings.sendActions(for: .editingChanged)
        }.store(in: &bag)
    }
}
