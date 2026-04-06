//
//  ContractViewController+Table.swift
//  OlchaInvestCore
//
//  Created by Akhrorkhuja on 29/05/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import UIKit
import OlchaUI

extension ContractViewController: TableDelegates {
    
    public enum Section: CaseIterable {
        case history, month
    }
    
    public var sections: [Section] {
        [.history]
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return input.historySkeleton.getCount(input.history.modelsCount)
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(ContractHistoryTableCell.self, for: indexPath)
        cell.configure(skeleton: input.historySkeleton)
        guard input.history.models.isGreater(indexPath) else {
            cell.prepareForReuse()
            return cell
        }
        cell.setup(with: input.history.models[indexPath.row], currency: output.currency.unwrap)
        return cell
    }
    
}
