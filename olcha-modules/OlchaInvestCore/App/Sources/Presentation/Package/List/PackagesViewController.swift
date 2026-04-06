//
//  PackagesViewController.swift
//  OlchaInvestCore
//
//  Created by Akhrorkhuja on 23/05/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import UIKit
import OlchaUI

public class PackagesViewController: BaseViewController<InvestNavigationBar> {
    
    private lazy var table: BaseTableView = {
        let table = BaseTableView()
        table.registerClass(forCell: PackagesTableCell.self)
        table.delegate = self
        table.dataSource = self
        table.configure()
        return table
    }()
    
    public var tooltips: [PackagesViewControllerTooltip] {
        let firstCell: PackagesTableCell? = table.cell(at: IndexPath(row: 0, section: 0))
        guard let firstCell = firstCell else { return [] }
        return [
            .percent(in: firstCell.percentBox),
            .term(in: firstCell.termBox),
            .currency(in: firstCell.currencyBox)
        ]
    }
    public let tooltipManager = TooltipManager()
    public var input: Input
    public var output: Output
    public let viewModel: PackagesViewModel
    public var coordinator: PackagesCoordinatorProtocol?
    
    init(
        viewModel: PackagesViewModel,
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
        refreshControl.endRefreshing()
        tooltipManager.destroy()
    }
    
    public override func setupViews() {
        container.addSubview(table)
        table.addSubview(refreshControl)
    }
    
    public override func autolayout() {
        table.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        placeholder.snp.remakeConstraints { make in
            make.edges.equalTo(table)
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
    }
    
    public override func configureViews() {
        placeholder.titleLabel.style(.semibold, 20)
        placeholder.setRefreshButton(hidden: false)
    }
    
    public override func languageUpdated() {
        navigationBar.setTitle("package_heading".localized(.olchaInvestCore))
        placeholder.setupTitle("packages_empty_placeholder".localized(.olchaInvestCore))
        initialRequest()
    }
    
    public override func setupObservers() {
        handle(viewModel.$packages, success: { [weak self] data in
            guard let self else { return }
            input.packages.models.append(contentsOf: data?.investments ?? [])
            input.packages.paging.finished(paginator: data?.paginator)
            reloadTable()
            setPlaceholder()
            guard let topView = topView else { return }
            tooltipManager.setup(tooltips: tooltips, darkView: topView)
        }, loading: { [weak self] isLoading in
            guard let self else { return }
            input.packagesSkeleton.isAnimating = isLoading
            reloadTable()
            isLoading ? refreshControl.beginRefreshing() : refreshControl.endRefreshing()
        })
        navigationBar.menuClicked { [weak self] in
            self?.coordinator?.presentMenu()
        }
        navigationBar.rightButtonClicked { [weak self] in
            self?.coordinator?.pushNotificationViewController()
        }
        placeholder.mainButtonClick { [weak self] in
            self?.coordinator?.selectHomeTab()
        }
        placeholder.refreshButtonClick { [weak self] in
            guard let self else { return }
            refresh()
            disablePlaceholder()
        }
    }
    
    public override func initialRequest() {
        input.reset()
        viewModel.loadPackages(page: 1)
    }
    
    public override func refreshList(_ sender: AnyObject) {
        refresh()
    }
    
    public func pushPackagesDetailViewController(investmentId: Int) {
        coordinator?.pushPackagesDetailViewController(investmentId: investmentId)
    }
    
}

private extension PackagesViewController {
    func reloadTable() {
        table.reloadData()
    }
    
    func refresh() {
        initialRequest()
    }
    
    func setPlaceholder() {
        let isEmpty = input.packages.models.isEmpty
        isEmpty ? enablePlaceholder() : disablePlaceholder()
    }
}
