//
//  CartVerificationPage+Table.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 11/10/22.
//



import UIKit
import OlchaBankCards
extension CartVerificationPage: UITableViewDelegate, UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cards.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let index = indexPath.row
        
        let cell = tableView.dequeue(BankCardRoom.self, for: indexPath)
        
        cell.setup(with: cards[index])
        cell.card.checkDefault()
        cell.card.isShown = ((openedMenuID ?? -2) == cards[index].id)
        
        cell.card.menuOpen = { [weak self] id in
            guard let self = self else { return }
            if self.openedMenuID == id {
                self.openedMenuID = nil
            } else {
                self.openedMenuID = id
            }
            tableView.reloadData()
            
            dismiss(animated: true)
        }
        
        cell.card.makeDefaultButton.clicked { [weak self] in
            guard let self = self else { return }
            let oldValue = self.cards[index].is_default ?? false
            self.cards.forEach { $0.is_default = false }
            self.cards[index].is_default = !oldValue
            if oldValue == false {
                self.makeDefault(card: self.cards[index])
            }
            self.openedMenuID = nil
            tableView.reloadData()
        }
        
        cell.card.deleteButton.settings.clicked { [weak self] in
            guard let self = self, cards.isGreater(index) else { return }
            self.openedMenuID = nil
            tableView.reloadRows(at: [indexPath], with: .none)
            self.delete(card: self.cards[index]) {
                
                self.cards.remove(at: index)
                
                tableView.reloadData()
            }
        }
        
        return cell
        
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if openedMenuID != nil {
            openedMenuID = nil
            cardsTable.reloadData()
        }
    }
}
