//
//  BankCards.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 15/03/23.
//

import Foundation
import OlchaCore
import Combine

public protocol BankCardsRepositoryProtocol {
    func loadBankCards() -> AnyPublisher<(BaseResponse<BankCardsData, EmptyData>), Never>
    func loadBalances() -> AnyPublisher<(BaseResponse<BalancesData, EmptyData>), Never>
    func loadTransactions() -> AnyPublisher<(BaseResponse<BankCardsTransactionsData, EmptyData>), Never>
}

public class BankCardsRepository: BaseRepository, BankCardsRepositoryProtocol {
    
    public func loadBankCards() -> AnyPublisher<(BaseResponse<BankCardsData, EmptyData>), Never> {
        let api: BankCardsAPI = .bankcards
        return manager.request(api: api,
                               isSingleRequest: false,
                               isCancellable: false)
    }
    
    public func loadBalances() -> AnyPublisher<(BaseResponse<BalancesData, EmptyData>), Never> {
        let api: BankCardsAPI = .balance
        return manager.request(api: api,
                               isSingleRequest: false,
                               isCancellable: false)
    }
    
    public func loadTransactions() -> AnyPublisher<(BaseResponse<BankCardsTransactionsData, EmptyData>), Never> {
        let api: BankCardsAPI = .transactions
        return manager.request(api: api)
    }
}
