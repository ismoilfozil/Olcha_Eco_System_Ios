//
//  CardViewController.swift
//  OlchaInvestCore
//
//  Created by Akhrorkhuja on 22/05/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import UIKit
import OlchaUI
import OlchaUtils
import OlchaBilling

public class CardViewController: InvestBaseViewController<TitleNavigationBar> {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.style(.semibold, 20)
        label.textColor = .olchaTextBlack
        return label
    }()
    
    private lazy var table: BaseTableView = {
        let table = BaseTableView()
        table.delegate = self
        table.dataSource = self
        table.registerClass(forCell: BillingVerificationCardRoom.self)
        table.registerClass(forCell: BillingPaymentHeaderRoom.self)
        table.registerClass(forCell: AddBillingCardRoom.self)
        table.contentInset.bottom = 72
        table.configure()
        return table
    }()
    
    private let continueButton: InvestOlchaButton = {
        let button = InvestOlchaButton()
        button.setButtonEnabled(false)
        button.settings.setTitleColor(.olchaBlackNeutral, for: .disabled)
        button.settings.setTitleColor(.lightGrayBackground, for: .normal)
        button.settings.titleLabel?.font = .style(.semibold, 16)
        button.round(10)
        return button
    }()
    
    public enum CardMode {
        case enroll
        case fill
    }
    
    public var mode: CardMode = .enroll {
        didSet { updateMode() }
    }
    public var input: Input
    public var output: Output
    public let viewModel: InvestCardViewModel
    public let billingViewModel: BillingViewModel
    public var coordinator: ProfitCoordinatorProtocol?
    public var investCoordinator: InvestCoordinatorProtocol?
    
    public init(
        viewModel: InvestCardViewModel,
        billingViewModel: BillingViewModel,
        input: Input = .init(),
        output: Output = .init()
    ) {
        self.viewModel = viewModel
        self.billingViewModel = billingViewModel
        self.input = input
        self.output = output
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func setupViews() {
        container.addSubview(titleLabel)
        container.addSubview(table)
        container.addSubview(continueButton)
    }
    
    public override func autolayout() {
        titleLabel.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview().inset(16)
        }
        table.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.left.right.bottom.equalToSuperview()
        }
        continueButton.snp.makeConstraints { make in
            make.bottom.left.right.equalToSuperview().inset(16)
        }
    }
    
    public override func configureViews() {
        languageUpdated()
    }
    
    public override func languageUpdated() {
        continueButton.setTitle("add_card_continue_button".localized(.olchaInvestCore))
    }
    
    public override func initialRequest() {
        billingViewModel.loadBankCards(
            filter: BillingPaymentFilter()
                .set(reflection: ReflectionType.invest_all_bank_cards)
        )
    }
    
    public override func setupObservers() {
        handle(billingViewModel.$bankCards, success: { [weak self] data in
            guard let self, let data else { return }
            input.parentCards = data.collection ?? []
            table.reloadData()
        }, loading: { [weak self] isLoading in
            guard let self else { return }
            input.cardsSkeleton.isAnimating = isLoading
            table.reloadData()
        })
        
        handle(viewModel.$hasWithdrawn, showLoader: true, success: { [weak self] hasWithdrawn in
            guard let self, let hasWithdrawn, hasWithdrawn else { return }
            presentSuccessViewController()
        })
        
        handle(viewModel.$hasContractCreated, showLoader: true, success: { [weak self] hasContractCreated in
            guard let self, let hasContractCreated, hasContractCreated else { return }
//            investCoordinator?.stop()
            presentSuccessViewController()
        })
        
        viewModel.$isCardSelected.sink { [weak self] isSelected in
            guard let self else { return }
            continueButton.setButtonEnabled(isSelected)
        }.store(in: &bag)
        
        continueButton.clicked { [weak self] in
            guard let self, let cardId = output.selectedCardId else { return }
            switch mode {
            case .enroll:
                withdrawProfit(cardId: cardId)
            case .fill:
                storeContract()
            }
        }
    }
    
    private func withdrawProfit(cardId: Int) {
        guard let investorId = output.investorId else { return }
        guard let contractId = output.contractId, let amount = output.amount else { return }
        guard let cardAlias = output.selectedCardAlias else { return }
        let request = WithdrawalRequest(
            investor_id: investorId,
            contract_id: contractId,
            bank_card_id: cardId,
            bank_card_alias: cardAlias,
            type: .bankCard,
            amount: amount
        )
        viewModel.withdrawProfit(model: request)
    }
    
    private func storeContract() {
        guard let contractName = output.contractName else { return }
        guard let investorId = output.investorId else { return }
        guard let investmentId = output.investmentId else { return }
        guard let startInvest = output.startInvest else { return }
        let request = AddContractRequest(
            currency: .uzs,
            investment_id: investmentId,
            investor_id: investorId,
            start_invest: startInvest,
            contract_name: contractName
        )
        viewModel.storeContract(model: request)
    }
    
    public func updateMode() {
        switch mode {
        case .enroll:
            navigationBar.setTitle("card_withdraw".localized(.olchaInvestCore))
            titleLabel.text = "card_withdraw_title".localized(.olchaInvestCore)
        case .fill:
            navigationBar.setTitle("card_fill".localized(.olchaInvestCore))
            titleLabel.text = "card_fill_title".localized(.olchaInvestCore)
        }
    }
    
    public func fillOutput(contractName: String, investorId: Int, investmentId: Int, startInvest: Double) {
        output.contractName = contractName
        output.investorId = investorId
        output.investmentId = investmentId
        output.startInvest = startInvest
    }
    
    public func fillOutput(contractId: Int, investorId: Int, amount: Double) {
        output.contractId = contractId
        output.investorId = investorId
        output.amount = amount
    }
    
    public func presentSuccessViewController() {
        coordinator?.presentSuccessViewController { [weak self] in
            self?.coordinator?.stop()
        }
        investCoordinator?.presentSuccessViewController { [weak self] in
            self?.popToRoot(mainTabIndex: InvestTab.home)
        }
    }
    
    public func pushAddCardViewController() {
        coordinator?.pushAddCardViewController()
        investCoordinator?.pushAddCardViewController()
    }
    
}
