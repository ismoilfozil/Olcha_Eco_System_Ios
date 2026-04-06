//
//  ContractPauseReasonModalViewController.swift
//  OlchaInvestCore
//
//  Created by Akhrorkhuja on 03/07/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import UIKit
import OlchaUI

public class ContractPauseReasonModalViewController: BaseModalViewController {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.style(.semibold, 18)
        label.textColor = .olchaBlackNeutral
        label.textAlignment = .center
        return label
    }()
    
    private lazy var table: DynamicTable = {
        let table = DynamicTable()
        table.registerClass(forCell: ContractPauseReasonTableCell.self)
        table.registerClass(forCell: ContractPauseReasonFieldTableCell.self)
        table.isScrollEnabled = false
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = .none
        return table
    }()
    
    private let confirmButton: IButton = {
        let button = IButton()
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .style(.medium, 16)
        button.backgroundColor = .olchaPrimaryColor
        button.round(10)
        return button
    }()
    
    public var input: Input
    public var output: Output
    public weak var coordinator: InvestHomeCoordinatorProtocol?
    
    public init(
        input: Input = .init(),
        output: Output = .init()
    ) {
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
        container.addSubview(confirmButton)
    }
    
    public override func autolayout() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        table.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview()
        }
        confirmButton.snp.makeConstraints { make in
            make.top.equalTo(table.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(40)
            make.bottom.equalToSuperview().offset(-20)
        }
    }
    
    public override func configureViews() {
        titleLabel.text = "contract_reason_title".localized(.olchaInvestCore)
        confirmButton.setTitle("contract_reason_confirm_button".localized(.olchaInvestCore), for: .normal)
    }
    
    public override func initialRequest() {
        table.reloadData()
    }
    
    public override func setupObservers() {
        confirmButton.clicked { [weak self] in
            guard let self, !output.reasonText.isEmpty else { return }
            coordinator?.pauseReasonObserver?.send(output.reasonText)
            coordinator?.dismissPresentedViewController()
        }
    }
    
}

public enum ContractPauseReasonRow: TableRowProtocol {
    case delete
    case problem
    case noProfit
    case cantWithdraw
    case other
    
    public var title: String {
        switch self {
        case .delete: return "contract_reason_delete".localized(.olchaInvestCore)
        case .problem: return "contract_reason_problem".localized(.olchaInvestCore)
        case .noProfit: return "contract_reason_no_profit".localized(.olchaInvestCore)
        case .cantWithdraw: return "contract_reason_cant_withdraw".localized(.olchaInvestCore)
        case .other: return "contract_reason_other".localized(.olchaInvestCore)
        }
    }
    
    public var icon: UIImage? {
        return nil
    }
    
}

public extension ContractPauseReasonModalViewController {
    struct Input {
        public init() {}
    }
    struct Output {
        var selectedRow: ContractPauseReasonRow = .delete
        var reasonText: String = ContractPauseReasonRow.delete.title
        
        public init() {}
    }
}

extension ContractPauseReasonModalViewController: TableDelegates {
    
    public enum Section {
        case `default`
        case other
    }
    
    public var sections: [Section] {
        var sections: [Section] = [.default]
        if output.selectedRow == .other {
            sections.append(.other)
        }
        return sections
    }
    
    public var rows: [ContractPauseReasonRow] {
        [.delete, .problem, .noProfit, .cantWithdraw, .other]
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch sections[section] {
        case .default: return rows.count
        case .other: return 1
        }
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch sections[indexPath.section] {
        case .default:
            let cell = tableView.dequeue(ContractPauseReasonTableCell.self, for: indexPath)
            let rowData = rows[indexPath.row]
            cell.setTitleLabel(rowData.title)
            cell.isChosen = output.selectedRow == rowData
            return cell
        case .other:
            let cell = tableView.dequeue(ContractPauseReasonFieldTableCell.self, for: indexPath)
            cell.reasonFieldObserver { [weak self] text in
                guard let self else { return }
                output.reasonText = text
            }
            return cell
        }
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard sections[indexPath.section] == .default else { return }
        let rowData = rows[indexPath.row]
        output.selectedRow = rowData
        output.reasonText = rowData.title
        tableView.reloadData()
    }
    
}
