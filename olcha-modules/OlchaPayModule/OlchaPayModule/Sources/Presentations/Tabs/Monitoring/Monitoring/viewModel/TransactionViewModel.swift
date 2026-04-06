//
//  TransactionViewModel.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 28/03/23.
//
import Foundation
import Combine
import OlchaUI
import OlchaUtils
import OlchaCore

public class TransactionViewModel: BaseViewModel {
    
    @Published var transactions: LoadingState<TransactionsData, BaseErrorType> = .standart
    @Published var initialTransactions: LoadingState<TransactionsData, BaseErrorType> = .standart
    @Published var transactionFeatures: LoadingState<TransactionsFeatures, BaseErrorType> = .standart
    @Published var transaction: LoadingState<TransactionData, BaseErrorType> = .standart
    
    private let loadTransactionsUseCase: LoadTransactionsProtocol
    private let loadTransactionsFeaturesUseCase: LoadTransactionsFeaturesProtocol
    private let loadTransactionUseCase: LoadTransactionProtocol
    
    public init(loadTransactionsUseCase: LoadTransactionsProtocol,
                loadTransactionsFeaturesUseCase: LoadTransactionsFeaturesProtocol,
                loadTransactionUseCase: LoadTransactionProtocol) {
        self.loadTransactionsUseCase = loadTransactionsUseCase
        self.loadTransactionsFeaturesUseCase = loadTransactionsFeaturesUseCase
        self.loadTransactionUseCase = loadTransactionUseCase
    }
    
    func loadInitialTransactions() {
        initialTransactions = .loading
        loadTransactionsUseCase.execute(filters: .init())
            .sink { [weak self] baseResponse in
                guard let self = self else { return }
                
                switch baseResponse.status {
                case .success:
                    self.initialTransactions = .success(baseResponse.response)
                    break
                default:
                    self.initialTransactions = .failure(.init(message: baseResponse.error))
                    break
                }
                
                self.transactions = .standart
            }.store(in: &bag)
    }
    
    func loadTransactions(filters: TransactionsFilters) {
        transactions = .loading
        loadTransactionsUseCase.execute(filters: filters)
            .sink { [weak self] baseResponse in
                guard let self = self else { return }
                
                switch baseResponse.status {
                case .success:
                    self.transactions = .success(baseResponse.response)
                    break
                default:
                    self.transactions = .failure(.init(message: baseResponse.error))
                    break
                }
                
                self.transactions = .standart
            }.store(in: &bag)
    }
    
    func loadTransactionFeatures() {
        transactionFeatures = .loading
        loadTransactionsFeaturesUseCase.execute()
            .sink { [weak self] baseResponse in
                guard let self = self else { return }
                switch baseResponse.status {
                case .success:
                    self.transactionFeatures = .success(baseResponse.response)
                    break
                default:
                    self.transactionFeatures = .failure(.init(message: baseResponse.error))
                    break
                }
                self.transactionFeatures = .standart
            }.store(in: &bag)
    }
    
    func loadTransaction(id: Int?, completed: ( () -> Void )? = nil ) {
        transaction = .loading
        
        guard let id = id else {
            transaction = .failure(.init(message: "transaction_not_found".localized()))
            transaction = .standart
            return
        }
        
        loadTransactionUseCase.execute(id: id)
            .sink { [weak self] baseResponse in
                guard let self = self else { return }
                switch baseResponse.status {
                case .success:
                    self.transaction = .success(baseResponse.response)
                default:
                    self.transaction = .failure(.init(message: baseResponse.error))
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    completed?()
                    self.transaction = .standart
                }
                
            }.store(in: &bag)
    }
}

