//
//  ProfileViewController+Table.swift
//  OlchaInvestCore
//
//  Created by Akhrorkhuja on 30/05/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import UIKit
import OlchaUI
import OlchaUtils

extension ProfileViewController: TableDelegates {
    public var rows: [ProfileRow] {
        var temp: [ProfileRow] = [.personal, .cards, .passport, .security]
        if InvestAppConfigurator.shared.isModule {
            // temp.insert(ModuleGeneratorHelper.shared.parentModule == .ecosystem ? .ecoSystem : .olcha, at: 0)
        }
        return temp
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rows.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(InvestHomeModalTableCell.self, for: indexPath)
        cell.horizontalEdge = 0
        cell.setup(with: rows[indexPath.row])
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch rows[indexPath.row] {
        case .olcha:
            ModuleGeneratorHelper.shared.generateParent()
        case .ecoSystem:
            ModuleGeneratorHelper.shared.generateParent()
        case .personal:
            coordinator?.pushPhonesVerification(withStatus: true)
        case .cards:
            coordinator?.pushBankCardsPage(withStatus: true)
        case .passport:
            coordinator?.pushPassportVerification(withStatus: true)
        case .security:
            coordinator?.pushSafety()
        }
    }
}
