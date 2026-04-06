//
//  CartCreditModalPage+Table.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 07/10/22.
//

import UIKit

extension CartCreditModalPage: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        creditTypes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch creditTypes[indexPath.row] {
        case .olcha:
            let cell = tableView.dequeue(OlchaCreditStoreRoom.self, for: indexPath)
            cell.limitBalance = balanceViewModel?.balance.value?.instalmentBalance
            cell.isChosen = (creditOrder.creditType == .olcha)
            cell.isReady = checkButtonState
            cell.creditOrder = creditOrder
            cell.expandeButton.clicked {
                cell.isExpande = !cell.isExpande
                cell.expandeButton.rotate(degree: .pi)

                UIView.animate(withDuration: cell.isExpande ? 0 : 0.3) {
                    cell.contentView.layoutIfNeeded()
                    tableView.performBatchUpdates(nil, completion: nil)
                }

            }
            cell.setup(with: products)
            cell.setupTempData()
            return cell
        case .anorbank:
            let cell = tableView.dequeue(AnorbankCreditStoreRoom.self, for: indexPath)
            cell.isChosen = (creditOrder.creditType == .anorbank)
            cell.isReady = checkButtonState
            cell.creditOrder = creditOrder
            cell.setup(with: products)
            
            
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        creditOrder.creditType = creditTypes[indexPath.row]
        tableView.reloadData()
    }
  
}
