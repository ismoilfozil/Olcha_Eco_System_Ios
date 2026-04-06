//
//  AboutViewController+Table.swift
//  OlchaInvestCore
//
//  Created by Akhrorkhuja on 23/06/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import UIKit
import OlchaUI
import OlchaUtils

extension AboutViewController: TableDelegates {
    public var rows: [AboutRow] {
        [.rate, .share]
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rows.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(AboutTableCell.self, for: indexPath)
        cell.setup(with: rows[indexPath.row])
        return cell
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let appUrl else { return }
        switch rows[indexPath.row] {
        case .rate:
            openURL(appUrl)
        case .share:
            showShare(text: appUrl)
        }
    }
}
