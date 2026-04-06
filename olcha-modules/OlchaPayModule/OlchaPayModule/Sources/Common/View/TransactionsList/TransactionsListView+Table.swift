//
//  File.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 04/02/23.
//

import UIKit
import OlchaUI
extension TransactionsListView: TableDelegates {
    public func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return actualCount
        case 1:
            return maxCount < listCount ? 1 : 0
        default:
            return 0
        }
        
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeue(TransactionRoom.self, for: indexPath)
            cell.setup(with: items[indexPath.row],
                       oldData: nil,
                       withDate: false)
            return cell
        case 1:
            let cell = tableView.dequeue(ShowAllRoom.self, for: indexPath)
            cell.setup()
            cell.showAllButton.clicked { [weak self] in
                guard let self = self else { return }
                self.showAllTransactionsObserver?()
            }
            return cell
        default:
            return .init()
        }
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0, 1:
            return rowHeight
        default:
            return 0
        }
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        switch indexPath.section {
        case 0:
            self.observers?.pushPaymentDetail.send(items[indexPath.row])
            break
        default:
            break
        }
        
    }
}

