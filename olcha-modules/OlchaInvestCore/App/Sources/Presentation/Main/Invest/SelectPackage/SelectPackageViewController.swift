//
//  SelectPackageViewController.swift
//  OlchaInvestCore
//
//  Created by Akhrorkhuja on 25/05/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import UIKit
import OlchaUI

public class SelectPackageViewController: BaseViewController<TitleNavigationBar> {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.style(.semibold, 20)
        label.textColor = .olchaTextBlack
        return label
    }()
    
    private lazy var table: BaseTableView = {
        let table = BaseTableView()
        table.registerClass(forCell: PackagesTableCell.self)
        table.delegate = self
        table.dataSource = self
        table.configure()
        return table
    }()
    
    private var tooltips: [SelectPackageViewControllerTooltip] {
        let firstCell: PackagesTableCell? = table.cell(at: IndexPath(row: 0, section: 0))
        guard let firstCell = firstCell else { return [] }
        return [
            .selectButton(in: firstCell.selectButton)
        ]
    }
    
    private let tooltipManager = TooltipManager()
    public var input: Input
    public var output: Output
    public let viewModel: PackagesViewModel
    public var coordinator: InvestCoordinatorProtocol?
    
    public init(
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
    
    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        tooltipManager.destroy()
    }
    
    public override func setupViews() {
        container.addSubview(titleLabel)
        container.addSubview(table)
    }
    
    public override func autolayout() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.left.right.equalToSuperview().inset(16)
        }
        table.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.left.right.bottom.equalToSuperview()
        }
    }
    
    public override func configureViews() {
        languageUpdated()
    }
    
    public override func languageUpdated() {
        titleLabel.text = "select_package".localized(.olchaInvestCore)
    }
    
    public override func setupObservers() {
        handle(viewModel.$packages, success: { [weak self] data in
            guard let self else { return }
            input.packages.models.append(contentsOf: data?.investments ?? [])
            input.packages.paging.finished(paginator: data?.paginator)
            table.reloadData {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    guard let topView = self.topView else { return }
                    self.tooltipManager.setup(tooltips: self.tooltips, darkView: topView)
                }
            }
        }, loading: { [weak self] isLoading in
            guard let self else { return }
            input.packagesSkeleton.isAnimating = isLoading
            table.reloadData()
        })
    }
    
    public override func initialRequest() {
        viewModel.loadPackages(page: 1)
    }
    
    public func pushSelectTermViewController(packageId: Int) {
        coordinator?.pushSelectTermViewController(packageId: packageId)
    }
    
    public func presentPackagesDetailViewController(investmentId: Int) {
        coordinator?.presentPackagesDetailViewController(investmentId: investmentId)
    }
    
}
