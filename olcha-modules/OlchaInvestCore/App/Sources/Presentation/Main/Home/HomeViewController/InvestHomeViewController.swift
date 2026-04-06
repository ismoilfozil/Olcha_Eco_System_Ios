//
//  InvestHomeViewController.swift
//  OlchaInvestCore
//
//  Created by Akhrorkhuja on 17/05/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import UIKit
import OlchaUI

public class InvestHomeViewController: BaseViewController<InvestNavigationBar> {

    private let topStack: UIStackView = {
        let stack = UIStackView()
        stack.distribution = .equalSpacing
        return stack
    }()
    
    private let homeTitle: UILabel = {
        let label = UILabel()
        label.style(.semibold, 20)
        return label
    }()
    
    private let addButton: IconButton = {
        let button = IconButton()
        button.setIcon(.plus?.withTintColor(.olchaPrimaryColor))
        return button
    }()
    
    private lazy var table: BaseTableView = {
        let table = BaseTableView()
        table.registerClass(forCell: InvestHomeTableCell.self)
        table.registerClass(forCell: InvestHomeAddTableCell.self)
        table.alwaysBounceVertical = true
        table.delegate = self
        table.dataSource = self
        table.configure()
        return table
    }()
    
    private lazy var islamicPopUp = IslamicPopUpViewController()
    
    public var tooltips: [InvestHomeViewControllerTooltip] {
        var tooltips: [InvestHomeViewControllerTooltip] = [
//            .packagesTabItem(in: tabBarController!.tabBar), //.items![1].view),
//            .profileTabItem(in: tabBarController!.tabBar), //.items![2].view),
            .menuButton(in: navigationBar.menuButton),
            .notificationButton(in: navigationBar.rightButton)
        ]
        if input.invests.modelsCount == 0 {
            tooltips.removeAll()
            tooltips.append(.investButton(in: placeholder.mainButton))
        }
        return tooltips
    }
    public var input: Input
    public var output: Output
    private let tooltipManager = TooltipManager()
    public let viewModel: InvestHomeViewModel
    public weak var coordinator: InvestHomeCoordinatorProtocol?
    
    public init(
        viewModel: InvestHomeViewModel,
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
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tooltipManager.destroy()
    }
    
    public override func setupObservers() {
        handle(viewModel.$invests) { [weak self] data in
            guard let self = self else { return }
            input.invests.models.append(contentsOf: data?.investorsContracts ?? [])
            input.invests.paging.finished(paginator: data?.paginator)
            reloadTable()
            setPlaceholder()
            guard let topView = topView else { return }
            tooltipManager.setup(tooltips: tooltips, darkView: topView)
        } loading: { [weak self] isLoading in
            guard let self else { return }
            input.investsSkeleton.isAnimating = isLoading
            reloadTable()
        }
        navigationBar.menuClicked { [weak self] in
            self?.coordinator?.presentMenu()
        }
        
        navigationBar.rightButtonClicked { [weak self] in
            self?.coordinator?.pushNotificationViewController()
        }
        
        addButton.clicked { [weak self] in
            self?.coordinator?.pushInvestViewController()
        }
        
        placeholder.mainButtonClick { [weak self] in
            self?.coordinator?.pushInvestViewController()
        }
        placeholder.refreshButtonClick { [weak self] in
            guard let self else { return }
            refresh()
            disablePlaceholder()
        }
    }
    
    public override func initialRequest() {
        viewModel.loadInvests(page: 1)
        viewModel.loadAccount()
    }
    
    public func loadMore(index: Int) {
        guard canLoad(index: index, paging: input.invests.paging, list: input.invests.models) else {
            return
        }
        viewModel.loadInvests(page: input.invests.paging.current)
    }
    
    public override func setupViews() {
        topStack.addArrangedSubview(homeTitle)
        topStack.addArrangedSubview(addButton)
        container.addSubview(topStack)
        container.addSubview(table)
        table.addSubview(refreshControl)
    }
    
    public override func autolayout() {
        topStack.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16)
            make.left.right.equalToSuperview().inset(16)
        }
        placeholder.snp.remakeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(topStack.snp.bottom)
        }
        placeholder.titleLabel.snp.updateConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(40)
        }
        placeholder.mainButton.snp.remakeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.equalTo(48)
            make.top.equalTo(placeholder.subtitleLabel.snp.bottom).offset(24)
            make.width.greaterThanOrEqualTo(160)
        }
        addButton.snp.makeConstraints { make in
            make.width.height.equalTo(28)
        }
        table.snp.makeConstraints { make in
            make.top.equalTo(topStack.snp.bottom).offset(16)
            make.left.right.bottom.equalToSuperview()
        }
    }
    
    public override func configureViews() {
        container.backgroundColor = .olchaWhite
        placeholder.titleLabel.style(.semibold, 20)
        placeholder.setRefreshButton(hidden: false)
        languageUpdated()
    }
    
    public override func languageUpdated() {
        navigationBar.setTitle("home_tab_item".localized(.olchaInvestCore))
        homeTitle.text = "contract_my_invests".localized(.olchaInvestCore)
        
        placeholder.setupTitle("home_empty_placeholder".localized(.olchaInvestCore))
        placeholder.setupButtonTitle("home_invest".localized(.olchaInvestCore))
        placeholder.setRefreshButton()
        reloadTable()
    }
    
    public override func refreshList(_ sender: AnyObject) {
        refresh()
    }
    
    public func showPopUpViewController(title: String?, description: String?) {
        islamicPopUp.setupContent(title: title, description: description)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.topViewController?.add(self.islamicPopUp)
        }
    }
    
    public func pushContractViewController(model: InvestorContractModel) {
        guard let contractId = model.id else { return }
        coordinator?.pushContractViewController(contractId: contractId)
    }
    
    public func pushInvestProfitViewController(model: InvestorContractModel) {
        guard let contractId = model.id else { return }
        coordinator?.pushInvestProfitViewController(contractId: contractId)
    }
    
    public func pushInvestViewController() {
        coordinator?.pushInvestViewController()
    }
    
    public func reloadTable() {
        table.reloadData()
    }
    
}

private extension InvestHomeViewController {
    func refresh() {
        input.reset()
        reloadTable()
        initialRequest()
        refreshControl.endRefreshing()
    }
    
    func setPlaceholder() {
        let isEmpty = input.invests.models.isEmpty
        isEmpty ? enablePlaceholder() : disablePlaceholder()
    }
}
