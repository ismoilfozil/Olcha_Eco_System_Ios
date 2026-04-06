//
//  CardListView+Table.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 04/02/23.
//

import UIKit
import OlchaUI
extension CardsListModalViewController: TableDelegates {
    public func numberOfSections(in tableView: UITableView) -> Int {
        items.count
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        section == (items.count - 1) ? 1 : 2
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeue(HomeCardListRoom.self, for: indexPath)
            cell.isSelectable = isSelectable
            if items.isGreater(indexPath) {
                cell.setup(model: items[indexPath.section])
                cell.isChosen = (makePaymentHelper?.selectedCard == items[indexPath.section])
            }

            return cell
        } else {
            let cell = tableView.dequeue(FooterItem.self, for: indexPath)
            cell.responder.withEdge = true
            return cell
        }
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        if indexPath.row == 0 {
            makePaymentHelper?.selectedCard = items[indexPath.section]
            makePaymentHelper?.observers.selectedCard.send(true)
        }
        
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return rowHeight
        } else {
            return separatorHeight
        }
    }
}
