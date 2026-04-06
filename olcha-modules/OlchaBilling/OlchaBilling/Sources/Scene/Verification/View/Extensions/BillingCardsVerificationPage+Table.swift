//
//  BillingCardsVerificationPage+Collection.swift
//  OlchaBilling
//
//  Created by Elbek Khasanov on 17/08/23.
//

import UIKit
import OlchaUI

extension BillingCardsVerificationPage: TableDelegates {
    public enum Section {
        case header
        case cards
        case add
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        getParentCardsCount()
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        getCardsCount(section: section) + 2
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch getSection(indexPath) {
        case .header:
            return getBankCardHeader(tableView, indexPath)
        case .add:
            return getAddBankCardRoom(tableView, indexPath)
        case .cards:
            return getBankCardRoom(tableView, indexPath)
        }
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch getSection(indexPath) {
        case .header:
            return UITableView.automaticDimension
        case .cards:
            return 160
        case .add:
            return UITableView.automaticDimension
        }
    }
    
}

fileprivate extension BillingCardsVerificationPage {
    
    func getBankCardIndex(_ indexPath: IndexPath) -> Int {
        (indexPath.row - 1)
    }
    
    func getSection(_ indexPath: IndexPath) -> Section {
        
        if indexPath.item == 0 {
            return .header
        } else if (getCardsCount(section: indexPath.section) + 1) == indexPath.item {
            return .add
        } else {
            return .cards
        }
        
    }
    
    func getBankCardRoom(_ tableView: UITableView, _ indexPath: IndexPath) -> BaseTableCell {
        let cell = tableView.dequeue(BillingVerificationCardRoom.self, for: indexPath)
        
        cell.configure(skeleton: input.cardsSkeleton)
        cell.reset()
        guard input.parentCards.isGreater(indexPath.section) else { return cell }

        let cardIndex = getBankCardIndex(indexPath)
        let parentBankCards = input.parentCards[indexPath.section]
        let bankCards = parentBankCards.bankCards
        guard bankCards.isGreater(cardIndex) else { return cell }
        let model = bankCards[cardIndex]
        
        cell.setup(with: model, currency: parentBankCards.currency, isSelected: output.selectedCard == indexPath)
        cell.responder.isShown = ((openedMenuID ?? -2) == model.getId())
        cell.responder.menuOpen = { [weak self] id in
            guard let self = self else { return }
            if self.openedMenuID == id {
                self.openedMenuID = nil
            } else {
                self.openedMenuID = id
            }
            tableView.reloadData()
        }
        cell.responder.makeDefaultButton.clicked { [weak self] in
            guard let self = self else { return }
            let oldValue = model.is_default ?? false
            bankCards.forEach { $0.is_default = false }
            bankCards[cardIndex].is_default = !oldValue
            if oldValue == false {
                self.makeDefault(card: model,
                                 parent: parentBankCards)
            }
            self.openedMenuID = nil
            setSelectedCard(cardId: model.getId())
            checkButtonState()
        }
        cell.responder.deleteButton.settings.clicked { [weak self] in
            guard let self = self else { return }
            self.openedMenuID = nil
            tableView.reloadRows(at: [indexPath], with: .none)
            self.delete(card: model,
                        parent: parentBankCards) {
                self.input.parentCards[indexPath.section].bank_cards?.remove(at: cardIndex)
                
                self.output.reset()
                self.setSelectedCard()
                self.checkButtonState()
            }
        }
        
        return cell
    }
    
    func getAddBankCardRoom(_ tableView: UITableView, _ indexPath: IndexPath) -> BaseTableCell {
        let cell = tableView.dequeue(AddBillingCardRoom.self, for: indexPath)
        cell.configure(skeleton: input.cardsSkeleton)
        cell.setup(with: "add_card".localized())
        cell.addButton.clicked { [weak self] in
            guard let self = self, input.parentCards.isGreater(indexPath.section) else { return }
            openedMenuID = nil
            tableView.reloadData()
            addBillingCardCoordinator?.presentAddBillingCard(
                filter: .init()
                        .set(payment_alias: input.parentCards[indexPath.section].alias),
                loadCards: output.loadCards,
                creditVerificationObserver: {
                    self.verifyCreditObserver()
                }
            )
        }
        
        return cell
    }
    
    func getBankCardHeader(_ tableView: UITableView, _ indexPath: IndexPath) -> BillingPaymentHeaderRoom {
        let cell = tableView.dequeue(BillingPaymentHeaderRoom.self, for: indexPath)
        cell.configure(skeleton: input.cardsSkeleton)
        if input.parentCards.isGreater(indexPath.section) {
            cell.setup(with: input.parentCards[indexPath.section].name)
        }
        return cell
    }
}

extension BillingCardsVerificationPage {
    fileprivate func getParentCardsCount() -> Int {
        if input.cardsSkeleton.isAnimating {
            return 1
        } else {
            return input.parentCards.count
        }
    }
    
    fileprivate func getCardsCount(section: Int) -> Int {
        if input.cardsSkeleton.isAnimating {
            return input.cardsSkeleton.count
        } else {
            return input.parentCards[section].bankCards.count
        }
    }
}
