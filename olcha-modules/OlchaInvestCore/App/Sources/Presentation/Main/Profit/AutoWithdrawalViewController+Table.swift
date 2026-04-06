//
//  AutoWithdrawalViewController+Table.swift
//  OlchaInvestCore
//
//  Created by Akhrorkhuja on 17/06/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import UIKit
import OlchaUI
import OlchaBilling

extension AutoWithdrawalViewController: TableDelegates {
    public enum Section {
        case header
        case cards
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        getParentCardsCount()
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        getCardsCount(section: section) + 1
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch getSection(indexPath) {
        case .header:
            return getBankCardHeader(tableView, indexPath)
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
        }
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard input.parentCards.isGreater(indexPath.section) else { return }
        switch getSection(indexPath) {
        case .cards:
            let isSelected = output.selectedCard == indexPath
            let parent = input.parentCards[indexPath.section]
            let card = parent.bankCards[indexPath.row - 1]
            output.selectedCardId = isSelected ? nil : card.getId()
            output.selectedCardAlias = isSelected ? nil : parent.alias
            output.selectedCard = isSelected ? nil : indexPath
            viewModel.isCardSelected = !isSelected
            break
        default: break
        }
        tableView.reloadData()
    }
}

fileprivate extension AutoWithdrawalViewController {
    
    func getBankCardIndex(_ indexPath: IndexPath) -> Int {
        indexPath.row - 1
    }
    
    func getSection(_ indexPath: IndexPath) -> Section {
        indexPath.item == 0 ? .header : .cards
    }
    
    func getBankCardRoom(_ tableView: UITableView, _ indexPath: IndexPath) -> BaseTableCell {
        let cell = tableView.dequeue(BillingVerificationCardRoom.self, for: indexPath)
        cell.setHorizontalContentInsets(inset: 0)
        cell.configure(skeleton: input.cardsSkeleton)
        
        guard input.parentCards.isGreater(indexPath.section) else { return cell }

        let cardIndex = getBankCardIndex(indexPath)
        let parentBankCards = input.parentCards[indexPath.section]
        let bankCards = parentBankCards.bankCards
        guard bankCards.isGreater(cardIndex) else { return cell }
        let model = bankCards[cardIndex]
        cell.setup(with: model, currency: parentBankCards.currency, isSelected: output.selectedCard == indexPath)
        cell.responder.menuButton.isHidden = true
        return cell
    }
    
    func getBankCardHeader(_ tableView: UITableView, _ indexPath: IndexPath) -> BillingPaymentHeaderRoom {
        let cell = tableView.dequeue(BillingPaymentHeaderRoom.self, for: indexPath)
        cell.setHorizontalContentInsets(inset: 0)
        cell.configure(skeleton: input.cardsSkeleton)
        if input.parentCards.isGreater(indexPath.section) {
            cell.setup(with: input.parentCards[indexPath.section].name)
        }
        return cell
    }
}

fileprivate extension AutoWithdrawalViewController {
    func getParentCardsCount() -> Int {
        input.cardsSkeleton.isAnimating ? 1 : input.parentCards.count
    }
    
    func getCardsCount(section: Int) -> Int {
        input.cardsSkeleton.isAnimating ? input.cardsSkeleton.count : input.parentCards[section].bankCards.count
    }
}
