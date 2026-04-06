//
//  CreditBuyModalPage+Table.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 26/07/22.
//

import UIKit
import Combine
extension CreditBuyModalPage: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch sections[section] {
        case .products:
            return 1
        case .credits:
            return creditTypes.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch sections[indexPath.section] {
        case .products:
            let cell = tableView.dequeue( CreditCountProductRoom.self, for: indexPath)
            cell.setup(with: product)
            cell.acceptClickObserver = acceptClickObserver
            cell.isReadyAccept = isReadyAccept
            cell.countObserver = countObserver
            return cell
        case .credits:
            switch creditTypes[indexPath.row] {
            case .olcha:
                let cell = tableView.dequeue(OlchaCreditStoreRoom.self, for: indexPath)
                
                cell.isReady = isReadyAccept
                cell.isChosen = (creditOrder.creditType == .olcha)
                cell.creditOrder = creditOrder
                cell.expandeButton.clicked {
                    cell.isExpande = !cell.isExpande
                    cell.expandeButton.rotate(degree: .pi)

                    UIView.animate(withDuration: cell.isExpande ? 0 : 0.3) {
                        cell.contentView.layoutIfNeeded()
                        tableView.performBatchUpdates(nil, completion: nil)
                    }

                }
                
                cell.setup(with: [product].compactMap { $0 } )
                cell.setupTempData()
                
                return cell
            case .anorbank:
                let cell = tableView.dequeue(AnorbankCreditStoreRoom.self, for: indexPath)
                cell.isChosen = (creditOrder.creditType == .anorbank)
                cell.isReady = isReadyAccept
                cell.creditOrder = creditOrder
                
                cell.setup(with: [product].compactMap { $0 } )
                
                return cell
            }
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
