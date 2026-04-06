//
//  BankCardsData.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 15/03/23.
//

import Foundation
public class BankCardsData: Codable {
    var bank_cards: [UserBankCardModel]?
    var total_sum: Double?
    
    func mergeBalances(_ balancesData: BalancesData?) {
        guard let bankCards = bank_cards,
              let balances = balancesData?.bank_cards else {
                  return
        }
        total_sum = balancesData?.total_sum ?? 0
        guard !balances.isEmpty else {
            return
        }

        for bankCard in bankCards {
            if let index = balances.firstIndex(where: { $0.id == bankCard.id }) {
                bankCard.bank_card?.balance = balances[index].balance
            }
        }
    }
    
    func mergeTransactions(_ bankCardsTransactionsData: BankCardsTransactionsData?) {
        guard let bankCards = bank_cards,
              let transactionsData = bankCardsTransactionsData?.bank_cards else {
                  return
        }
        
        guard !transactionsData.isEmpty else {
            return
        }

        for bankCard in bankCards {
            if let index = transactionsData.firstIndex(where: { $0.id == bankCard.id }) {
                bankCard.transactions = transactionsData[index].transactions
            }
        }
    }
}


