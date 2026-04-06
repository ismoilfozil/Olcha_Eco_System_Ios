//
//  BankCardsUseCase.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 15/03/23.
//

import Foundation
import Combine
import OlchaCore
public protocol LoadBankCardsProtocol {
    func execute() -> AnyPublisher<BaseResponse<BankCardsData, EmptyData>, Never>
}

public protocol LoadBalancesProtocol {
    func execute() -> AnyPublisher<BaseResponse<BalancesData, EmptyData>, Never>
}

public protocol LoadBankCardsTransactionsProtocol {
    func execute() -> AnyPublisher<BaseResponse<BankCardsTransactionsData, EmptyData>, Never>
}


public enum BankCardsUseCase {
    public class LoadBankCards: LoadBankCardsProtocol {
        
        private var bankCardsRepository: BankCardsRepositoryProtocol
        
        public init(bankCardsRepository: BankCardsRepositoryProtocol) {
            self.bankCardsRepository = bankCardsRepository
        }
        
        public func execute() -> AnyPublisher<BaseResponse<BankCardsData, EmptyData>, Never> {
            return bankCardsRepository.loadBankCards()
        }
    }
    
    public class LoadBalances: LoadBalancesProtocol {
        
        private var bankCardsRepository: BankCardsRepositoryProtocol
        
        public init(bankCardsRepository: BankCardsRepositoryProtocol) {
            self.bankCardsRepository = bankCardsRepository
        }
        
        public func execute() -> AnyPublisher<BaseResponse<BalancesData, EmptyData>, Never> {
            return bankCardsRepository.loadBalances()
        }
    }
    
    public class LoadTransactions: LoadBankCardsTransactionsProtocol {
        
        private var bankCardsRepository: BankCardsRepositoryProtocol
        
        public init(bankCardsRepository: BankCardsRepositoryProtocol) {
            self.bankCardsRepository = bankCardsRepository
        }
        
        public func execute() -> AnyPublisher<BaseResponse<BankCardsTransactionsData, EmptyData>, Never> {
            return bankCardsRepository.loadTransactions()
        }
    }
}
