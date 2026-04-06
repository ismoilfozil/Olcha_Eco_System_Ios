//
//  MonitoringViewController+Table.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 22/02/23.
//

import UIKit
import OlchaUI
extension MonitoringViewController: UITableViewDelegate, UITableViewDataSource {
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return skeleton.isAnimating ? skeleton.count : transactions.count
        default:
            return filters.paging.footerLoadingCount()
        }
        
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeue(TransactionRoom.self, for: indexPath)
            cell.configure(skeleton: skeleton)
            cell.skeletonChecker(isAnimating: skeleton.isAnimating)
            if !skeleton.isAnimating {
                if transactions.isGreater(indexPath) {
                    cell.setup(with: transactions[indexPath.row],
                               oldData: getLastTransaction(indexPath))
                }
            }
            cell.horizontalEdge = 16
            
            configureBorders(indexPath, cell)
            
            loadMore(indexPath.row)
            
            return cell
        default:
            let cell = tableView.dequeue(FooterItem.self, for: indexPath)
            cell.corner(0)
            cell.responder.backgroundColor = .olchaLightNeutralGray
            cell.responder.configureIndicator()
            return cell
        }
        
        
        
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        switch indexPath.section {
        case 0:
            observers.pushPaymentDetail.send(transactions[indexPath.row])
            break
        default:
            break
        }
    }
    
    private func isFirstRow(_ indexPath: IndexPath) -> Bool {
        indexPath.row == 0
    }
    
    private func isLastRow(_ indexPath: IndexPath) -> Bool {
        indexPath.row == (transactions.count - 1)
    }
    
    private func getLastTransaction(_ indexPath: IndexPath) -> TransactionModel? {
        let index = indexPath.row - 1
        
        guard index >= 0, index < transactions.count else {
            return nil
        }
        
        let transaction = transactions[index]
        return transaction
    }
    
    private func configureBorders( _ indexPath: IndexPath, _ cell: BaseTableCell) {
        switch (isFirstRow(indexPath), isLastRow(indexPath)) {
            case (true, true):
                cell.corner(12)
                break
            case (false, true):
                cell.bottomCorner()
                break
            case (true, false):
                cell.topCorner()
                break
            case (false, false):
                cell.corner(0)
                break
        }
    }
}
