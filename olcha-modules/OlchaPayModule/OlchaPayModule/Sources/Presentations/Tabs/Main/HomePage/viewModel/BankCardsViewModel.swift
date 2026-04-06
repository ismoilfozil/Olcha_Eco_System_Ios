//
//  BankCardsViewModel.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 15/03/23.
//

import Foundation
import Combine
import OlchaUI
import OlchaCore
import OlchaAuth

public class BankCardsViewModel: BaseViewModel {
    
    private let loadBankCardsUseCase: LoadBankCardsProtocol
    private let loadBalancesUseCase: LoadBalancesProtocol
    private let loadBankCardsTransactionsUseCase: LoadBankCardsTransactionsProtocol
    
    @Published public var bankCards: LoadingState<BankCardsData, BaseErrorType> = .standart
    @Published public var balances: LoadingState<BalancesData, BaseErrorType> = .standart
    @Published public var transactions: LoadingState<BankCardsTransactionsData, BaseErrorType> = .standart
    
    
    public var bankCardsData: BankCardsData? {
        didSet {
            cardsUpdated()
        }
    }
    
    public var balancesData: BalancesData? {
        didSet {
            cardsUpdated()
        }
    }
    
    private var transactionsData: BankCardsTransactionsData? {
        didSet {
            cardsUpdated()
        }
    }
    
    
    public init(loadBankCardsUseCase: LoadBankCardsProtocol,
                loadBalancesUseCase: LoadBalancesProtocol,
                loadBankCardsTransactionsUseCase: LoadBankCardsTransactionsProtocol
    ) {
        self.loadBankCardsUseCase = loadBankCardsUseCase
        self.loadBalancesUseCase = loadBalancesUseCase
        self.loadBankCardsTransactionsUseCase = loadBankCardsTransactionsUseCase
    }
    
    public func initialLoad(withBankCards: Bool = true) {
        if withBankCards {
            loadBankCards(forceLoad: true)
        }
        loadBalances()
        loadTransactions()
    }
    
    public func loadBankCards(forceLoad: Bool = false) {
        guard (bankCardsData?.bank_cards?.isEmpty ?? true) || forceLoad else {
            bankCards = .success(bankCardsData)
            return
        }
        self.bankCards = .loading
        
        loadBankCardsUseCase.execute()
            .receive(on: RunLoop.main)
            .sink { [weak self] baseResponse in
                guard let self = self else { return }
                switch baseResponse.status {
                case .success:
                    self.bankCardsData = baseResponse.response
                    break
                default:
                    self.bankCards = .failure(.init(message: baseResponse.error))
                    break
                }
                bankCards = .standart
            }.store(in: &bag)
    }
    
    public func loadBalances() {
        guard AuthGlobalDefaults.isUser(), balances != .loading else { return }
        balances = .loading
        loadBalancesUseCase.execute()
            .receive(on: RunLoop.main)
            .sink { [weak self] baseResponse in
                guard let self = self else { return }
                switch baseResponse.status {
                case .success:
                    self.balances = .success(baseResponse.response)
                    self.balancesData = baseResponse.response
                    break
                default:
                    self.balances = .failure(.init(message: baseResponse.error))
                    break
                }
                balances = .standart
            }.store(in: &bag)
    }
    
    public func loadBalancesWithoutRunloop() {
        guard AuthGlobalDefaults.isUser(), balances != .loading else { return }
        balances = .loading
        loadBalancesUseCase.execute()
            .sink { [weak self] baseResponse in
                guard let self = self else { return }
                switch baseResponse.status {
                case .success:
                    self.balances = .success(baseResponse.response)
                    self.balancesData = baseResponse.response
                    break
                default:
                    self.balances = .failure(.init(message: baseResponse.error))
                    break
                }
                balances = .standart
            }.store(in: &bag)
    }
    
    public func loadTransactions() {
        self.transactions = .loading
        
        loadBankCardsTransactionsUseCase.execute()
            .receive(on: RunLoop.main)
            .sink { [weak self] baseResponse in
                guard let self = self else { return }
                switch baseResponse.status {
                case .success:
                    self.transactions = .success(baseResponse.response)
                    self.transactionsData = baseResponse.response
                    break
                default:
                    self.transactions = .failure(.init(message: baseResponse.error))
                    break
                }
                transactions = .standart
            }.store(in: &bag)
    }
    
    private func cardsUpdated() {
        
        bankCardsData?.mergeBalances(balancesData)
        
        bankCardsData?.mergeTransactions(transactionsData)
        
        bankCards = .success(bankCardsData)
    }
}
