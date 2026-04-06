//
//  InvestProfitViewController.swift
//  OlchaInvestCore
//
//  Created by Akhrorkhuja on 22/05/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import UIKit
import OlchaUI

public class InvestProfitViewController: BaseViewController<TitleNavigationBar> {
    
    private let scrollView: IScrollView = {
        let scrollView = IScrollView()
        scrollView.container.spacing = 22
        return scrollView
    }()
    
    private let topSectionContainer = UIView()
    
    private let profitLabel: UILabel = {
        let label = UILabel()
        label.style(.medium, 14)
        label.textColor = .olchaLightTextColornnnnnn
        return label
    }()
    
    private let profitAmountLabel: UILabel = {
        let label = UILabel()
        label.style(.semibold, 20)
        label.textColor = .olchaGreen
        return label
    }()
    
    private let profitTextField: InvestTField = {
        let textfield = InvestTField()
        textfield.placeholder = "0"
        textfield.type = .amount
        textfield.addRule(TextFieldRules.profitAmountRule())
        return textfield
    }()
    
    private let withdrawalButton: InvestOlchaButton = {
        let button = InvestOlchaButton()
        button.isEnabled = false
        button.settings.setTitleColor(.olchaBlackNeutral, for: .disabled)
        button.settings.setTitleColor(.lightGrayBackground, for: .normal)
        button.settings.titleLabel?.font = .style(.semibold, 16)
        button.round(10)
        return button
    }()
    
    private let withdrawalAllButton: IButton = {
        let button = IButton()
        button.backgroundColor = .clear
        button.setTitleColor(.olchaPrimaryColor, for: .normal)
        button.titleLabel?.font = .style(.semibold, 16)
        return button
    }()
    
    private let autoWithdrawalButtonContainer = UIView()
    
    private let autoWithdrawalConfigureButton: IButton = {
        let button = IButton()
        button.round(8)
        button.backgroundColor = .olchaLightNeutralGray
        button.titleLabel?.style(.medium, 16)
        button.setTitleColor(.olchaLightTextColornnnnnn, for: .normal)
        button.titleLabel?.textAlignment = .left
        return button
    }()
    
    private let autoWithdrawalSwitch: UISwitch = {
        let switchButton = UISwitch()
        switchButton.onTintColor = .olchaPrimaryColor
        switchButton.isUserInteractionEnabled = false
        return switchButton
    }()
    
    private let autoWithdrawalSwitchButton = IButton()
    
    let historyStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 12
        return stackView
    }()
    
    private var model: InvestorContractModel?
    private var profitAmount: Double = 0.0
    public var contractId: Int?
    public var coordinator: ProfitCoordinatorProtocol?
    public let viewModel: ContractViewModel
    
    var historyModels: [InvestProfitHistoryModel] = [] {
        didSet {
            createHistory()
        }
    }
    
    public init(viewModel: ContractViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        profitTextField.becomeFirstResponder()
        loadContract()
        loadWithdrawHistory()
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        profitTextField.resignFirstResponder()
    }
    
    public override func setupViews() {
        container.addSubview(scrollView)
        scrollView.addArrangedSubview(view: topSectionContainer, horizontalEdge: 0)
        scrollView.addArrangedSubview(view: historyStackView, horizontalEdge: 0)
        
        topSectionContainer.addSubview(profitLabel)
        topSectionContainer.addSubview(profitAmountLabel)
        topSectionContainer.addSubview(profitTextField)
        topSectionContainer.addSubview(withdrawalButton)
        topSectionContainer.addSubview(withdrawalAllButton)
        topSectionContainer.addSubview(autoWithdrawalButtonContainer)
        
        autoWithdrawalButtonContainer.addSubview(autoWithdrawalConfigureButton)
        autoWithdrawalButtonContainer.addSubview(autoWithdrawalSwitch)
        autoWithdrawalButtonContainer.addSubview(autoWithdrawalSwitchButton)
    }
    
    public override func autolayout() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        profitLabel.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview().inset(16)
        }
        profitAmountLabel.snp.makeConstraints { make in
            make.top.equalTo(profitLabel.snp.bottom).offset(4)
            make.left.right.equalToSuperview().inset(16)
        }
        profitTextField.snp.makeConstraints { make in
            make.top.equalTo(profitAmountLabel.snp.bottom).offset(12)
            make.left.right.equalToSuperview().inset(16)
        }
        withdrawalButton.snp.makeConstraints { make in
            make.top.equalTo(profitTextField.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(40)
        }
        withdrawalAllButton.snp.makeConstraints { make in
            make.top.equalTo(withdrawalButton.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(40)
        }
        autoWithdrawalButtonContainer.snp.makeConstraints { make in
            make.top.equalTo(withdrawalAllButton.snp.bottom).offset(24)
            make.left.right.equalToSuperview().inset(16)
            make.bottom.equalToSuperview()
        }
        
        autoWithdrawalConfigureButton.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(12)
            make.left.equalToSuperview()
            make.height.equalTo(40)
            make.right.equalTo(autoWithdrawalSwitchButton.snp.left).inset(-24)
        }
        
        autoWithdrawalSwitchButton.snp.makeConstraints { make in
            make.top.equalTo(autoWithdrawalSwitch.snp.top)
            make.left.equalTo(autoWithdrawalSwitch.snp.left)
            make.right.equalTo(autoWithdrawalSwitch.snp.right)
            make.bottom.equalTo(autoWithdrawalSwitch.snp.bottom)
        }
        
        autoWithdrawalSwitch.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview()
        }
        
    }
    
    public override func configureViews() {
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(autoWithdrawalStackTapped))
//        autoWithdrawalStack.addGestureRecognizer(tapGesture)
        languageUpdated()
        
        createHistory()
    }
    
    public override func languageUpdated() {
        withdrawalButton.setTitle("profit_withdraw_button".localized(.olchaInvestCore))
        withdrawalAllButton.setTitle("profit_withdraw_all".localized(.olchaInvestCore), for: .normal)
        navigationBar.setTitle("profit_withdraw".localized(.olchaInvestCore))
        profitLabel.text = "profit_income_sum".localized(.olchaInvestCore)
        profitTextField.topHint = "invest_amount".localized(.olchaInvestCore)
        autoWithdrawalConfigureButton.setTitle("profit_autowithraw".localized(.olchaInvestCore), for: .normal)
    }
    
    public func setup(with data: InvestorContractModel) {
        model = data
        let profit = data.profit_balance.unwrap.withoutSpace.double
        profitAmount = profit
        profitAmountLabel.text = "\(data.profit_balance.unwrap.originalPriceWithoutCurrency) \(data.unwrappedCurrency)"
        profitTextField.placeholder = "0 \(data.unwrappedCurrency)"
        autoWithdrawalSwitch.setOn(data.auto_withdrawal.orFalse, animated: true)
        profitTextField.addRule(TextFieldRules.maxAmountRule(max: data.profit_balance?.double ?? 0))
    }
    
    public override func setupObservers() {
        handle(viewModel.$contract, showLoader: true, success: { [weak self] data in
            guard let self, let data else { return }
            setup(with: data)
        }, failure: { [weak self] _ in
            self?.navigationController?.dismiss(animated: true)
        })
        handle(viewModel.$widthdrawHistoryData, success: { [weak self] data in
            guard let self else { return }
            self.historyModels = data?.withdrawalRequest ?? []
        })

        
        handle(viewModel.$hasAutoWithdrawalStatusChanged, showLoader: true, success: { [weak self] data in
            guard let self, let data else { return }
            autoWithdrawalSwitch.setOn(data.is_active, animated: true)
        })
        profitTextField.observeText { [weak self] in
            guard let self = self else { return }
            let isBigger = profitTextField.getValue().double <= profitAmount
            withdrawalButton.isEnabled = profitTextField.isValidated() && isBigger
        }
        withdrawalButton.clicked { [weak self] in
            let investorId = InvestGlobalDefaults.account.investorId
            let contractId = self?.model?.id
            let amount = self?.profitTextField.getValue().double
            guard let self, let contractId, let investorId, let amount else { return }
            coordinator?.pushInvestCardViewController(contractId: contractId, investorId: investorId, amount: amount)
        }
        withdrawalAllButton.clicked { [weak self] in
            self?.profitTextField.text = self?.profitAmount.string.originalPriceWithoutCurrency
            self?.profitTextField.settings.sendActions(for: .editingChanged)
        }

        autoWithdrawalSwitchButton.clicked { [weak self] in
            guard let self else { return }
            autoWithdrawalSwitchValueChanged()
        }
        
        autoWithdrawalConfigureButton.clicked { [weak self] in
            guard let self else { return }
            pushAutoWithdrawalViewController()
        }
        
    }
    
    private func autoWithdrawalSwitchValueChanged() {
        guard let contractId else { return }
        
        guard model?.auto_withdrawal != nil else {
            pushAutoWithdrawalViewController()
            return
        }
        
        viewModel.toggleAutoWithdrawalStatus(contractId: contractId, completion: nil)
    }
    
    private func pushAutoWithdrawalViewController() {
        guard let contractId else { return }
        coordinator?.pushAutoWithdrawalViewController(contractId: contractId) { [weak self] in
            guard let self else { return }
            if !autoWithdrawalSwitch.isOn {
                viewModel.toggleAutoWithdrawalStatus(contractId: contractId, completion: nil)
            }
        }
    }
    
    public override func initialRequest() {}
    
    private func loadContract() {
        guard let contractId = contractId else { return }
        viewModel.loadContract(id: contractId)
    }
    
    private func loadWithdrawHistory() {
        guard let contractId = contractId else { return }
        viewModel.loadWithdrawHistory(id: contractId)
    }
}
