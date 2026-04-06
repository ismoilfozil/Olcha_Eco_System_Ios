//
//  SelectTermViewController.swift
//  OlchaInvestCore
//
//  Created by Akhrorkhuja on 26/05/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import UIKit
import OlchaUI

public class SelectTermViewController: BaseViewController<TitleNavigationBar> {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.style(.semibold, 20)
        label.textColor = .olchaTextBlack
        return label
    }()
    
    private let labelStack: UIStackView = {
        let stack = UIStackView()
        stack.distribution = .equalSpacing
        return stack
    }()
    
    private let termLabel: UILabel = {
        let label = UILabel()
        label.style(.medium, 16)
        label.textColor = .olchaShadeBlack
        return label
    }()
    
    private let riskLabel: UILabel = {
        let label = UILabel()
        label.style(.medium, 16)
        label.textColor = .olchaShadeBlack
        return label
    }()
    
    private lazy var table: BaseTableView = {
        let table = BaseTableView()
        table.registerClass(forCell: SelectTermTableCell.self)
        table.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 60, right: 0)
        table.delegate = self
        table.dataSource = self
        table.configure()
        return table
    }()
    
    private let continueButton: InvestOlchaButton = {
        let button = InvestOlchaButton()
        button.setButtonEnabled(false)
        button.settings.setTitleColor(.lightGrayBackground, for: .normal)
        button.settings.setTitleColor(.olchaTextBlack, for: .disabled)
        button.settings.titleLabel?.font = .style(.semibold, 16)
        button.round(10)
        return button
    }()
    
    private var tooltips: [SelectTermViewControllerTooltip] {
        let firstCell: SelectTermTableCell? = table.cell(at: IndexPath(row: 0, section: 0))
        guard let firstCell = firstCell else { return [] }
        return [
            .term(in: firstCell.contentView)
        ]
    }
    
    private let tooltipManager = TooltipManager()
    public var input: Input
    public var output: Output
    public let viewModel: SelectTermViewModel
    public weak var coordinator: BasePackagesCoordinatorProtocol?
    
    public init(
        viewModel: SelectTermViewModel,
        input: Input = .init(),
        output: Output = .init()
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
    }
    
    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        tooltipManager.destroy()
    }
    
    public override func setupViews() {
        container.addSubview(titleLabel)
        container.addSubview(labelStack)
        labelStack.addArrangedSubview(termLabel)
        labelStack.addArrangedSubview(riskLabel)
        container.addSubview(table)
        container.addSubview(continueButton)
    }
    
    public override func autolayout() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.left.right.equalToSuperview().inset(16)
        }
        labelStack.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(16)
        }
        table.snp.makeConstraints { make in
            make.top.equalTo(labelStack.snp.bottom).offset(16)
            make.left.right.bottom.equalToSuperview()
        }
        continueButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(12)
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(40)
        }
    }
    
    public override func configureViews() {
        languageUpdated()
    }
    
    public override func languageUpdated() {
        titleLabel.text = "select_condition".localized(.olchaInvestCore)
        termLabel.text = "contract_term".localized(.olchaInvestCore)
        riskLabel.text = "contract_percent".localized(.olchaInvestCore)
        continueButton.setTitle("add_card_continue_button".localized(.olchaInvestCore))
    }
    
    public override func setupObservers() {
        handle(viewModel.$terms, success: { [weak self] data in
            guard let self else { return }
            input.terms.models = data?.investments ?? []
            input.terms.paging.finished(paginator: data?.paginator)
            table.reloadData()
            let selectedPackageId = data?.investments.firstIndex(where: { $0.id == self.output.childPackageId })
            let firstRow = IndexPath(row: selectedPackageId ?? 0, section: 0)
            if table.hasRow(at: firstRow) {
                let row = table.cellForRow(at: firstRow) as? SelectTermTableCell
                row?.isChosen = true
                output.term = input.terms.models[firstRow.row]
                changeContinueButton(to: output.term != nil)
                table.reloadData()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                guard let topView = self.topView else { return }
                self.tooltipManager.setup(tooltips: self.tooltips, darkView: topView)
            }
        }, loading: { [weak self] isLoading in
            guard let self else { return }
            input.termsSkeleton.isAnimating = isLoading
            table.reloadData()
        })
        continueButton.clicked { [weak self] in
            guard let self, let term = output.term else { return }
            coordinator?.termObserver.send(term)
            coordinator?.pushAmountViewController()
        }
    }
    
    public override func initialRequest() {
        if let packageId = output.packageId {
            viewModel.loadTerms(packageId: packageId)
        }
    }
    
    public func fillOutput(packageId: Int, childPackageId: Int?) {
        output.packageId = packageId
        output.childPackageId = childPackageId
    }
    
    public func changeContinueButton(to isEnabled: Bool) {
        continueButton.setButtonEnabled(isEnabled)
    }
    
}
