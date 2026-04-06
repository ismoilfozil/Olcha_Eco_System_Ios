//
//  ContractViewController.swift
//  OlchaInvestCore
//
//  Created by Akhrorkhuja on 29/05/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import UIKit
import OlchaUI
import Combine

public class ContractViewController: BaseViewController<TitleNavigationBar> {
    
    private lazy var scrollView: IScrollView = {
        let scrollView = IScrollView()
        scrollView.horizontalEdge()
        scrollView.settings.alwaysBounceVertical = true
        scrollView.container.spacing = 16
        scrollView.settings.showsVerticalScrollIndicator = false
        scrollView.settings.contentInset = UIEdgeInsets(top: 16, left: 0, bottom: 72, right: 0)
        return scrollView
    }()
    
    private let idLabel: UILabel = {
        let label = UILabel()
        label.style(.medium, 14)
        label.textColor = .olchaInfoColor
        label.text = "\t"
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.style(.semibold, 20)
        label.textColor = .olchaTextBlack
        label.numberOfLines = 0
        label.text = "\t"
        return label
    }()
    
    private let profitView = InvestProfitView()
    
    private let pauseButton: IButton = {
        let button = IButton()
        button.setTitleColor(.olchaPrimaryColor, for: .normal)
        button.titleLabel?.font = .style(.medium, 16)
        button.backgroundColor = .olchaLightPrimaryRed
        button.round(10)
        return button
    }()
    
    private let resumeButton: IButton = {
        let button = IButton()
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .style(.medium, 16)
        button.backgroundColor = .olchaPrimaryColor
        button.round(10)
        button.isHidden = true
        return button
    }()
    
    private let boxStack: UIStackView = {
        let stack = UIStackView()
        stack.spacing = 16
        stack.distribution = .fillEqually
        return stack
    }()
    
    private let percentBox: RateBoxView = {
        let box = RateBoxView()
        box.setRateImage(image: .percentBoxIcon)
        box.setRateBoxGradient(.olchaLightOrangeGradient)
        box.setRateAmountLabelColor(.olchaOrange)
        return box
    }()
    
    private let termBox: RateBoxView = {
        let box = RateBoxView()
        box.setRateImage(image: .chartBoxIcon)
        box.setRateBoxGradient(.olchaLightBlueGradient)
        box.setRateAmountLabelColor(.olchaInfoColor)
        return box
    }()
    
    private let packageTextField: InvestTField = {
        let textfield = InvestTField()
        textfield.type = .default
        textfield.setDisabled()
        textfield.setDisabledBackground()
        return textfield
    }()
    
    private let statisticsLabel: UILabel = {
        let label = UILabel()
        label.style(.semibold, 20)
        label.textColor = .olchaTextBlack
        label.numberOfLines = 0
        label.isHidden = true
        return label
    }()
    
    private var priceChart: OlchaChart?
    
    private let historyLabel: UILabel = {
        let label = UILabel()
        label.style(.semibold, 20)
        label.textColor = .olchaTextBlack
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var table: DynamicTable = {
        let table = DynamicTable()
        table.registerClass(forCell: ContractHistoryTableCell.self)
        table.isScrollEnabled = false
        table.delegate = self
        table.dataSource = self
        return table
    }()
    
    private let deleteButton: IButton = {
        let button = IButton()
        button.setTitleColor(.olchaPrimaryColor, for: .normal)
        button.setTitleColor(.olchaNeutral700, for: .disabled)
        button.titleLabel?.font = .style(.medium, 16)
        button.backgroundColor = .olchaLightNeutralGray
        button.isEnabled = false
        button.round(10)
        return button
    }()
    
    private let deleteWarning = InvestWarningView()
    
    private let reinvestButton: InvestOlchaButton = {
        let button = InvestOlchaButton()
        button.settings.setTitleColor(.olchaBlackNeutral, for: .disabled)
        button.settings.setTitleColor(.lightGrayBackground, for: .normal)
        button.settings.titleLabel?.font = .style(.medium, 16)
        button.round(10)
        return button
    }()
    
    public var contractId: Int?
    
    private var model: InvestorContractModel?
    
    private var tooltips: [ContractViewControllerTooltip] {
        var tooltips: [ContractViewControllerTooltip] = [
            .name(in: titleLabel),
            .amounts(in: profitView.contentStack),
            .withdraw(in: profitView.withdrawalButton),
            .details(in: boxStack),
            .package(in: packageTextField),
        ]
        if !input.chart.models.isEmpty {
            tooltips.append(.chart(in: statisticsLabel))
        }
        if !input.history.models.isEmpty {
            tooltips.append(.history(in: historyLabel))
        }
        return tooltips
    }
    private let tooltipManager = TooltipManager()
    public var input: Input
    public var output: Output
    public let viewModel: ContractViewModel
    public let pauseReasonObserver = PassthroughSubject<String, Never>()
    public weak var coordinator: InvestHomeCoordinatorProtocol?
    
    public init(
        viewModel: ContractViewModel,
        input: Input = .init(),
        output: Output = .init()
    ) {
        self.viewModel = viewModel
        self.input = input
        self.output = output
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tooltipManager.didViewAppear = true
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        input.skeletonViews.forEach({ $0.layoutSkeletonIfNeeded() })
    }
    
    public override func setupViews() {
        container.addSubview(scrollView)
        container.addSubview(reinvestButton)
        scrollView.settings.addSubview(refreshControl)
        scrollView.addArrangedSubview(idLabel)
        scrollView.addArrangedSubview(titleLabel)
        scrollView.addArrangedSubview(profitView)
        scrollView.addArrangedSubview(pauseButton)
        scrollView.addArrangedSubview(resumeButton)
        scrollView.addArrangedSubview(boxStack)
        boxStack.addArrangedSubview(percentBox)
        boxStack.addArrangedSubview(termBox)
        scrollView.addArrangedSubview(packageTextField)
        scrollView.addArrangedSubview(statisticsLabel)
        scrollView.addArrangedSubview(historyLabel)
        scrollView.addArrangedSubview(table)
        scrollView.addArrangedSubview(deleteButton)
        scrollView.addArrangedSubview(deleteWarning)
    }
    
    public override func autolayout() {
        scrollView.container.setCustomSpacing(4, after: idLabel)
        scrollView.container.setCustomSpacing(20, after: profitView)
        scrollView.container.setCustomSpacing(24, after: packageTextField)
        scrollView.container.setCustomSpacing(22, after: statisticsLabel)
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        [pauseButton, resumeButton, deleteButton].forEach { view in
            view.snp.makeConstraints({ $0.height.equalTo(40) })
        }
        boxStack.snp.makeConstraints { make in
            make.height.equalTo(80)
        }
        deleteWarning.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
        }
        reinvestButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().offset(-8)
            make.height.equalTo(40)
        }
    }
    
    public override func configureViews() {
        drawHistory()
        languageUpdated()
        configureSkeleton()
    }
    
    public func configureSkeleton() {
        input.skeletonViews = [
            idLabel,
            packageTextField,
            titleLabel,
            profitView,
            boxStack,
            packageTextField,
            statisticsLabel,
            historyLabel,
            deleteWarning,
            pauseButton,
            resumeButton,
            deleteButton,
            reinvestButton,
        ]
        input.skeletonViews.forEach({
            $0.isSkeletonable = true
            $0.showAnimatedGradientSkeleton()
        })
    }
    
    public override func languageUpdated() {
        navigationBar.setTitle("contract_my_invests".localized(.olchaInvestCore))
        profitView.languageUpdated()
        pauseButton.setTitle("contract_pause".localized(.olchaInvestCore), for: .normal)
        resumeButton.setTitle("contract_resume".localized(.olchaInvestCore), for: .normal)
        percentBox.setRateLabelText("contract_percent".localized(.olchaInvestCore))
        termBox.setRateLabelText("contract_term".localized(.olchaInvestCore))
        statisticsLabel.text = "contract_statistics".localized(.olchaInvestCore)
        historyLabel.text = "contract_history".localized(.olchaInvestCore)
        packageTextField.placeholder = "contract_category_title".localized(.olchaInvestCore)
        packageTextField.topHint = "package".localized(.olchaInvestCore)
        deleteButton.setTitle("contract_cancel".localized(.olchaInvestCore), for: .normal)
        deleteWarning.setWarningText("contract_cancel_warning".localized(.olchaInvestCore))
        reinvestButton.setTitle("contract_reinvest".localized(.olchaInvestCore))
        
        table.reloadData()
    }
    
    public override func initialRequest() {
        guard let contractId = contractId else { return }
        viewModel.combineContractData()
        viewModel.loadContract(id: contractId)
        viewModel.loadContractHistory(id: contractId)
        viewModel.loadContractChart(id: contractId)
    }
    
    public override func setupObservers() {
        handle(viewModel.$loadedAllContractData, success: { [weak self] isLoaded in
            guard let self, isLoaded.orFalse else { return }
            guard let topView = topView else { return }
            tooltipManager.setup(tooltips: tooltips, darkView: topView, scrollView: scrollView.settings)
        })
        
        handle(viewModel.$contract, success: { [weak self] contract in
            guard let self, let contract else { return }
            model = contract
            setup(with: contract)
            updateContractState(status: contract.status_type)
        }, loading: { [weak self] isLoading in
            guard let self else { return }
            updateSkeleton(isLoading: isLoading)
        })

        handle(viewModel.$contractHistory, success: { [weak self] data in
            guard let self = self else { return }
            input.history.models = data?.contractHistory ?? []
            table.reloadData()
        }, loading: { [weak self] isLoading in
            guard let self else { return }
            input.historySkeleton.isAnimating = isLoading
            table.reloadData()
        })
        
        handle(viewModel.$contractChart, success: { [weak self] data in
            guard let self = self else { return }
            input.chart.models = data?.chart_items ?? []
            drawHistory()
        })
        
        handle(viewModel.$hasContractStatusChanged, success: { [weak self] data in
            guard let self, let data else { return }
            model = data
            updateContractState(status: data.status_type)
        })
        
        profitView.clicked { [weak self] in
            guard let self, let contractId else { return }
            coordinator?.pushInvestProfitViewController(contractId: contractId)
        }
        
        pauseReasonObserver.sink { [weak self] text in
            guard let self, let contractId = contractId else { return }
            viewModel.toggleContractStatus(id: contractId, status: false, comment: text)
        }.store(in: &bag)
        
        pauseButton.clicked { [weak self] in
            guard let self else { return }
            coordinator?.pauseReasonObserver = pauseReasonObserver
            coordinator?.presentContractPauseReasonModalViewController()
        }
        
        resumeButton.clicked { [weak self] in
            guard let self, let contractId = contractId else { return }
            viewModel.toggleContractStatus(id: contractId, status: true, comment: "test")
        }
        
        deleteButton.clicked { [weak self] in
            guard let self, let contractId = contractId else { return }
            presentPhoneAlert(contractId: contractId)
        }
        
        reinvestButton.clicked { [weak self] in
            guard let self, let currency = output.currency else { return }
            guard let contractId, let reflection = model?.billing_reflection else { return }
            coordinator?.pushReinvestViewController(
                contractId: contractId,
                reflection: reflection,
                currency: currency
            )
        }
    }
    
    public func setup(with contract: InvestorContractModel) {
        print("calc contract", contract)
        idLabel.text = "ID: №\(contract.id.orZero)"
        packageTextField.text = contract.investment_name
        titleLabel.text = contract.contract_name
        profitView.setCurrency(contract.unwrappedCurrency)
        
        output.currency = contract.unwrappedCurrency
        
        profitView.setTotalAmount(contract.invest_sum.orZero.string)
        profitView.setProfitOut(contract.getProfitOut())
        profitView.setProfitInside(contract.profit_balance ?? "0")
        
        
        percentBox.setRateAmountLabelText("\(contract.percent.orZero.int.string)%")
        let termString = String(format: "term_value".localized(.olchaInvestCore), contract.term.orZero.string)
        termBox.setRateAmountLabelText(termString)
        
        updateContractState(status: contract.status_type)
    }
    
    public override func refreshList(_ sender: AnyObject) {
        input.reset()
        initialRequest()
        refreshControl.endRefreshing()
    }
}

private extension ContractViewController {
    func updateSkeleton(isLoading: Bool = true) {
        input.skeletonViews.forEach { skeletonView in
            skeletonView.layoutSkeletonIfNeeded()
            if isLoading {
                skeletonView.showAnimatedGradientSkeleton()
            } else {
                skeletonView.hideSkeleton()
            }
        }
    }
    
    func updateContractState(isPaused: Bool, contractStatus: Bool = true) {
        pauseButton.isHidden = isPaused || !contractStatus
        resumeButton.isHidden = !isPaused || !contractStatus
        deleteWarning.isHidden = isPaused || !contractStatus
        deleteButton.isHidden = !contractStatus
        deleteButton.isEnabled = isPaused && contractStatus
        deleteButton.backgroundColor = isPaused && contractStatus ? .olchaLightPrimaryRed : .olchaLightNeutralGray
    }
    
    func updateContractState(status: StatusType) {
        pauseButton.isHidden = false
        resumeButton.isHidden = false
        deleteWarning.isHidden = false
        deleteButton.isHidden = true
        deleteButton.isEnabled = false
        deleteButton.backgroundColor = .olchaLightPrimaryRed
        reinvestButton.isHidden = false
        switch status {
        case .active:
            resumeButton.isHidden = true
        case .inactive:
            pauseButton.isHidden = true
            resumeButton.isHidden = true
            deleteWarning.isHidden = true
            reinvestButton.isHidden = true
        case .paused:
            pauseButton.isHidden = true
            deleteButton.isHidden = false
            deleteButton.isEnabled = true
        case .pending_for_payment:
            pauseButton.isHidden = true
            resumeButton.isHidden = true
            deleteButton.isHidden = false
            deleteButton.isEnabled = true
            reinvestButton.isHidden = true
        }
    }

    func presentPhoneAlert(contractId: Int) {
        let alert = UIAlertController(title: "contract_phone_alert_title".localized(.olchaInvestCore), message: "contract_phone_alert_message".localized(.olchaInvestCore), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "contract_phone_alert_cancel_button".localized(.olchaInvestCore), style: .default))
        alert.addAction(UIAlertAction(title: "contract_phone_alert_yes_button".localized(.olchaInvestCore), style: .destructive, handler: { [weak self] _ in
            self?.viewModel.deleteContract(id: contractId)
        }))
        present(alert, animated: true)
    }
    
    func drawHistory() {
        priceChart?.removeFromSuperview()
        priceChart = nil
        statisticsLabel.isHidden = input.chart.models.isEmpty
        guard !input.chart.models.isEmpty else {
            return
        }
        priceChart = OlchaChart()
        guard let priceChart = priceChart else {
            return
        }
        priceChart.currency = output.currency
        
        scrollView.container.insertArrangedSubview(priceChart, at: 8)
        
        priceChart.snp.remakeConstraints { make in
            make.height.equalTo(140)
        }
        priceChart.data.removeAll()
        priceChart.data = input.chart.models.map({
            PriceHistory(price: $0.invest_sum.orZero.int, date: $0.date)
        })
    }
}
