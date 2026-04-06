//
//  HelpViewController+Table.swift
//  OlchaInvestCore
//
//  Created by Akhrorkhuja on 06/06/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import UIKit
import OlchaUI

extension HelpViewController: TableDelegates {
    public var rows: [HelpRow] {
        [.phone, .message, .faq]
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rows.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(InvestHomeModalTableCell.self, for: indexPath)
        cell.setup(with: rows[indexPath.row])
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch rows[indexPath.row] {
        case .phone:
            presentPhoneAlert()
        case .faq:
            pushFaqViewController()
        case .message:
            pushWriteUsViewController()
        default: break
        }
    }
}
