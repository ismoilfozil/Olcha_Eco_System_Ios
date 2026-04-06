//
//  ReinvestViewController+Table.swift
//  OlchaInvestCore
//
//  Created by Akhrorkhuja on 22/06/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import UIKit
import OlchaUI

extension ReinvestViewController: TableDelegates {
    public enum Section: CaseIterable {
        case card, addCard
    }
    
    public var sections: [Section] {
        [.card, .addCard]
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch sections[section] {
        case .card: return input.cards.models.count
        case .addCard: return 1
        }
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch sections[indexPath.section] {
        case .card:
            let cell = tableView.dequeue(InvestCardTableCell.self, for: indexPath)
            cell.setup(with: input.cards.models[indexPath.row])
            if let row = output.selectedCardRowId {
                cell.isChosen = indexPath.row == row
            }
            return cell
        case .addCard:
            let cell = tableView.dequeue(InvestCardAddTableCell.self, for: indexPath)
            cell.setup()
            return cell
        }
    }
}
