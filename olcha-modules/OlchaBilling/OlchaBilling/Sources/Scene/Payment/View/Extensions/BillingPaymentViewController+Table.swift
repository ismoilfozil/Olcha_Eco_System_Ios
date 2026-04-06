//
//  BillingPaymentViewController+Collection.swift
//  OlchaBilling
//
//  Created by Elbek Khasanov on 20/06/23.
//

import UIKit
import OlchaUI
import OlchaUtils

extension BillingPaymentViewController: TableDelegates {
    
    public enum Section {
        case card
        case webhook
        case balance
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch sections[section] {
        case .card:
            print("ctc", getBankCardsCount(at: section) + 2)
            return getBankCardsCount(at: section) + 2
        case .webhook:
            return getWebhooksCount()
        case .balance:
            return getBalancesCount()
        }
        
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch sections[indexPath.section] {
        case .card:
            if isHeaderRow(indexPath) {
                return getBankCardHeaderItem(tableView, indexPath)
            } else if isFooterRow(indexPath) {
                return getAddBankCardRoom(tableView, indexPath)
            } else {
                return getBankCardRoom(tableView, indexPath)
            }
        case .webhook:
            guard !isHeaderRow(indexPath) else {
                return getHeaderItem(tableView, indexPath, getHeaderTitle(indexPath))
            }
            return getWebhooksRoom(tableView, indexPath)
        case .balance:
            guard !isHeaderRow(indexPath) else {
                return getHeaderItem(tableView, indexPath, getHeaderTitle(indexPath))
            }
            return getBalancesRoom(tableView, indexPath)
        }
        
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        guard !isHeaderRow(indexPath) else {
            return UITableView.automaticDimension
        }
        switch sections[indexPath.section] {
        case .card:
            return 60
        case .webhook:
            return 64
        case .balance:
            return 64
        }
        
    }
    
    private func isHeaderRow(_ indexPath: IndexPath) -> Bool {
        indexPath.row == 0
    }
    
    private func isFooterRow(_ indexPath: IndexPath) -> Bool {
        (indexPath.row) == (getBankCardsCount(at: indexPath.section) + 1)
    }
    
}

public extension BillingPaymentViewController {
    
    fileprivate func getHeaderTitle(_ indexPath: IndexPath) -> String {
        switch sections[indexPath.section] {
        case .card:
            return input.bankCardParents[indexPath.section].name ?? ""
        case .webhook:
            return "with_application".localized(.billing)
        case .balance:
            return "Olcha Balance"
        }
    }
    
    fileprivate func getHeaderItem(_ tableView: UITableView,
                                   _ indexPath: IndexPath,
                                   _ title: String?) -> UITableViewCell {
        
        let cell = tableView.dequeue(BillingPaymentHeaderRoom.self, for: indexPath)
        cell.setup(with: title)
        return cell
        
    }
    
    fileprivate func getBankCardHeaderItem(_ tableView: UITableView,
                                           _ indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeue(BillingPaymentHeaderRoom.self, for: indexPath)
        cell.configure(skeleton: input.bankCardsSkeleton)
        if input.bankCardParents.isGreater(indexPath.section) {
            let bankCardParent = input.bankCardParents[indexPath.section]
            cell.setup(with: bankCardParent.name)
        } else {
            cell.prepareForReuse()
        }
        return cell
        
    }
    
    fileprivate func getBankCardRoom(_ tableView: UITableView,
                                     _ indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeue(BillingCardRoom.self, for: indexPath)
        cell.configure(skeleton: input.bankCardsSkeleton)
        
        guard input.bankCardParents.isGreater(indexPath.section) else { cell.prepareForReuse(); return cell }
        let parentBankCard = input.bankCardParents[indexPath.section]
        
        guard parentBankCard.bankCards.isGreater(indexPath.row - 1) else { cell.prepareForReuse(); return cell }
        let bankCard = parentBankCard.bankCards[indexPath.row - 1]
        
        cell.configure(skeleton: input.bankCardsSkeleton)
        cell.setup(imageUrl: bankCard.card_icon,
                   name: bankCard.name,
                   number: bankCard.getNumber())
        
        cell.isChosen = input.billingFilter.payment.checkIdentifier(alias: parentBankCard.alias,
                                                                    id: bankCard.id?.int)
        
        cell.button.clicked { [weak self] in
            guard let self = self else { return }
            input.select(parentBankCard, bankCard)
            itemSelected()
        }
        return cell
    }
    
    fileprivate func getAddBankCardRoom(_ tableView: UITableView,
                                        _ indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeue(AddBillingCardRoom.self, for: indexPath)
        cell.configure(skeleton: input.bankCardsSkeleton)
        cell.setup(with: "add_card".localized())
        if input.bankCardParents.isGreater(indexPath.section) {
            let parentBankCard = input.bankCardParents[indexPath.section]
            cell.addButton.clicked { [weak self] in
                guard let self = self else { return }
                output.addCardObserver.send(parentBankCard)
            }
        } else {
            cell.prepareForReuse()
        }
        return cell
        
    }

    fileprivate func getWebhooksRoom(_ tableView: UITableView,
                                     _ indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeue(WebhooksRoom.self, for: indexPath)
        cell.skeleton = input.webhooksSkeleton
        cell.selectedPayment = input.billingFilter.payment
        cell.setup(with: input.webhooks)
        cell.selectObserver = { [weak self] data in
            guard let self = self else { return }
            input.select(data)
            itemSelected()
        }
        return cell
        
    }
    
    fileprivate func getBalancesRoom(_ tableView: UITableView,
                                     _ indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeue(BalancesRoom.self, for: indexPath)
        cell.skeleton = input.balancesSkeleton
        cell.selectedPayment = input.billingFilter.payment
        cell.setup(with: input.balances)
        cell.selectObserver = { [weak self] data in
            guard let self = self else { return }
            
            input.select(data)
            itemSelected()
        }
        return cell
        
    }
    
}

extension BillingPaymentViewController {
    
    fileprivate func getWebhooksCount() -> Int {
        if input.webhooksSkeleton.isAnimating {
            return 2
        } else {
            return input.webhooks.isEmpty ? 0 : 2
        }
    }
    
    fileprivate func getBalancesCount() -> Int {
        if input.balancesSkeleton.isAnimating {
            return 2
        } else {
            return input.balances.isEmpty ? 0 : 2
        }
    }
    
    fileprivate func getBankCardsCount(at section: Int) -> Int {
        if input.bankCardsSkeleton.isAnimating {
            return input.bankCardsSkeleton.count
        } else {
            return input.bankCardParents[section].bankCards.count
        }
    }
    
}
