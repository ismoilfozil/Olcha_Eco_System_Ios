//
//  AutoWithdrawalViewController.swift
//  OlchaInvestCore
//
//  Created by Akhrorkhuja on 01/06/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import UIKit
import OlchaUI
import OlchaBilling
import OlchaUtils

public class AutoWithdrawalViewController: BaseViewController<TitleNavigationBar> {
    
    private lazy var scrollView: IScrollView = {
        let scrollView = IScrollView()
        scrollView.horizontalEdge()
        scrollView.container.spacing = 12
        scrollView.settings.alwaysBounceVertical = true
        scrollView.settings.showsVerticalScrollIndicator = false
        scrollView.settings.contentInset = UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 0)
        return scrollView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.style(.semibold, 20)
        label.textColor = .olchaTextBlack
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.style(.regular, 14)
        label.textColor = .olchaTextBlack
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    private let sliderLabelStack: UIStackView = {
        let stack = UIStackView()
        stack.distribution = .equalSpacing
        return stack
    }()
    
    private let sliderLeftLabel: UILabel = {
        let label = UILabel()
        label.style(.medium, 12)
        label.textColor = .olchaTextBlack
        return label
    }()
    
    private let sliderCenterLabel: UILabel = {
        let label = UILabel()
        label.style(.semibold, 14)
        label.textColor = .olchaTextBlack
        return label
    }()
    
    private let sliderRightLabel: UILabel = {
        let label = UILabel()
        label.style(.medium, 12)
        label.textColor = .olchaTextBlack
        return label
    }()
    
    private lazy var customSliderView = CustomSliderView()
    
    private let cardTitleLabel: UILabel = {
        let label = UILabel()
        label.style(.semibold, 20)
        label.textColor = .olchaTextBlack
        return label
    }()
    
    private lazy var table: DynamicTable = {
        let table = DynamicTable()
        table.delegate = self
        table.dataSource = self
        table.isScrollEnabled = false
        table.registerClass(forCell: BillingVerificationCardRoom.self)
        table.registerClass(forCell: AddBillingCardRoom.self)
        table.registerClass(forCell: BillingPaymentHeaderRoom.self)
        table.configure()
        table.contentInset = .init(top: 0, left: 0, bottom: 100, right: 0)
        return table
    }()
    
    private let saveButton: InvestOlchaButton = {
        let button = InvestOlchaButton()
        button.setButtonEnabled(false)
        button.settings.setTitleColor(.olchaBlackNeutral, for: .disabled)
        button.settings.setTitleColor(.lightGrayBackground, for: .normal)
        button.settings.titleLabel?.font = .style(.semibold, 16)
        button.round(10)
        return button
    }()
    
    public var input: Input
    public var output: Output
    public var contractId: Int?
    public let billingViewModel: BillingViewModel
    public let viewModel: InvestCardViewModel
    public weak var coordinator: ProfitCoordinatorProtocol?
    
    public var completion: (() -> Void)?
    
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
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func setupViews() {
        container.addSubview(scrollView)
        scrollView.addArrangedSubview(titleLabel)
        scrollView.addArrangedSubview(descriptionLabel)
        scrollView.addArrangedSubview(sliderLabelStack)
        sliderLabelStack.addArrangedSubview(sliderLeftLabel)
        sliderLabelStack.addArrangedSubview(sliderCenterLabel)
        sliderLabelStack.addArrangedSubview(sliderRightLabel)
        scrollView.addArrangedSubview(customSliderView)
        scrollView.addArrangedSubview(cardTitleLabel)
        scrollView.addArrangedSubview(table)
        container.addSubview(saveButton)
    }
    
    public override func autolayout() {
        scrollView.container.setCustomSpacing(8, after: titleLabel)
        scrollView.container.setCustomSpacing(20, after: descriptionLabel)
        scrollView.container.setCustomSpacing(24, after: customSliderView)
        scrollView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(saveButton.snp.top)
        }
        customSliderView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(30)
        }
        table.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
        }
        saveButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(40)
            make.bottom.equalToSuperview().inset(12)
        }
    }
    
    public override func configureViews() {
        sliderLeftLabel.text = "10%"
        sliderRightLabel.text = "100%"
        customSliderView.setup(min: 10, max: 100, delegate: self)
        customSliderView.forcedStep = 10
        customSliderView.sendValueChangedAction()
        languageUpdated()
    }
    
    public override func languageUpdated() {
        navigationBar.setTitle("profit_withdraw".localized(.olchaInvestCore))
        titleLabel.text = "autowithdraw".localized(.olchaInvestCore)
        descriptionLabel.text = "autowithdraw_desc".localized(.olchaInvestCore)
        cardTitleLabel.text = "card_withdraw_title".localized(.olchaInvestCore)
        saveButton.setTitle("save_button".localized(.olchaInvestCore))
        table.reloadData()
    }
    
    public override func initialRequest() {
        if let contractId {
            viewModel.autoWithdrawal(contractId: contractId)
        }
        billingViewModel.loadBankCards(
            filter: BillingPaymentFilter()
                .set(reflection: ReflectionType.invest_all_bank_cards)
        )
        table.reloadData()
    }
    
    public override func setupObservers() {
        viewModel.$autowithdrawal
            .combineLatest(billingViewModel.$bankCards)
            .sink(receiveValue: { [weak self] (autowithdrawal, bankCards) in
                guard let self else { return }
                let isLoading = autowithdrawal == .loading || bankCards == .loading
                input.parentCards = bankCards.value?.collection ?? []
                input.cardsSkeleton.isAnimating = bankCards == .loading
                input.autoWithdrawalData = autowithdrawal.value
                table.reloadData {
                    guard !isLoading else { return }
                    self.customSliderView.forcedStep = autowithdrawal.value?.percentage ?? 0
                    self.fillData()
                }
            }).store(in: &bag)
        
        handle(viewModel.$hasStoredAutoWithdrawal, showLoader: true, success: { [weak self] hasStored in
            guard let self, let hasStored, hasStored else { return }
            completion?()
            coordinator?.navigationController.popViewController(animated: true)
        })
        
        viewModel.$isCardSelected.sink { [weak self] isSelected in
            guard let self else { return }
            saveButton.setButtonEnabled(isSelected)
        }.store(in: &bag)
        
        saveButton.clicked { [weak self] in
            guard let self, let contractId else { return }
            guard let cardId = output.selectedCardId, let alias = output.selectedCardAlias else { return }
            viewModel.storeAutoWithdraw(
                contractId: contractId,
                bankCard: (cardId, alias),
                percentage: customSliderView.currenctStep
            )
        }
    }

    private func fillData() {
        let cardId = input.autoWithdrawalData?.bank_card_id
        setSelectedCard(cardId: cardId)
    }
    
    public func setSelectedCard(cardId: Int?) {
        for (s, collection) in input.parentCards.enumerated() {
            if let cardId = cardId {
                // Setting card based on ID
                if let r = collection.bankCards.firstIndex(where: { $0.getId() == cardId }) {
                    output.selectedCardAlias = collection.alias
                    output.selectedCardId = cardId
                    output.selectedCard = IndexPath(row: r + 1, section: s)
                }
            } else {
                // Setting default card
                guard output.selectedCardId == nil, let bankCard = collection.bankCards.first else { continue }
                output.selectedCardAlias = collection.alias
                output.selectedCardId = bankCard.getId()
                output.selectedCard = IndexPath(row: 1, section: s)
            }
            if output.selectedCardAlias != nil || output.selectedCardId != nil {
                viewModel.isCardSelected = true
            }
            table.reloadData()
        }
    }
}

extension AutoWithdrawalViewController: CustomSliderViewDelegate {
    public func valueChanged(value: Int) {
        sliderCenterLabel.text = "\(value)%"
    }
}
