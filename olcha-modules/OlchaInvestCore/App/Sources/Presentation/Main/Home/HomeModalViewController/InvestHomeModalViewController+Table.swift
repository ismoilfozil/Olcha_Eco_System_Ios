//
//  InvestHomeModalViewController+Table.swift
//  OlchaInvestCore
//
//  Created by Akhrorkhuja on 19/05/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import UIKit
import OlchaUI

extension InvestHomeModalViewController: TableDelegates {
    
    var rows: [InvestDetailRow] {
        [.topUp, .withdrawal, .history, .stats]
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rows.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(InvestHomeModalTableCell.self, for: indexPath)
        cell.setup(with: rows[indexPath.row])
        return cell
    }

}
