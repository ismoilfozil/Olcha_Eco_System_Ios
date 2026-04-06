//
//  BalansCardsPage.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 07/11/22.
//

import UIKit
import OlchaBankCards
extension BalanceCardsPage: UITableViewDelegate, UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cards.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let index = indexPath.row
        
        let cell = tableView.dequeue(BankCardRoom.self, for: indexPath)
        
        if cards.isGreater(index) {
            cell.setup(with: cards[index])
            cell.card.checkSelection(isSelected: cards[index] == selectedCard)
        }
        
        cell.card.menuButton.isHidden = true
        
        
        return cell
        
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        if cards.isGreater(indexPath) {
            selectedCard = cards[indexPath.row]
        }
        tableView.reloadData()
    }

}
