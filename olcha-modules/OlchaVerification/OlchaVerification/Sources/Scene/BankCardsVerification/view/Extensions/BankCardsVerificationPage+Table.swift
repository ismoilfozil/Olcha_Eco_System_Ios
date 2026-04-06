//
//  VerificationPage3+Table.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 18/09/22.
//

import OlchaBankCards
import UIKit
import OlchaUI

extension BankCardsVerificationPage: UITableViewDelegate, UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch sections[section] {
        case .card:
            return cards.count
        case .add:
            return 1
        }
        
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch sections[indexPath.section] {
        case .card:
            return getCardRoom(tableView: tableView, indexPath: indexPath)
        case .add:
            return getAddCardRoom(tableView: tableView, indexPath: indexPath)
        }
        
        
        
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if openedMenuID != nil {
            openedMenuID = nil
            cardsTable.reloadData()
        }
    }
    
}

extension BankCardsVerificationPage {
    enum Section {
        case card
        case add
    }
    
    fileprivate func getCardRoom(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
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
            guard let self = self else { return }
            self.openedMenuID = nil
            tableView.reloadRows(at: [indexPath], with: .none)
            self.delete(card: self.cards[index]) {
                
                self.cards.remove(at: index)
                
                tableView.reloadData()
            }
        }
        
        return cell
    }
    
    fileprivate func getAddCardRoom(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeue(AddBillingCardRoom.self, for: indexPath)
        cell.setup(with: "add_card".localized())
        
        cell.addButton.clicked { [weak self] in
            guard let self = self else { return }
            self.coordinator?.presentAddCardPage(loadCards: self.loadCards)
        }
        return cell
        
    }
    
}
