//
//  SavedTransactionsViewModel.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 05/04/23.
//
import Foundation
import Combine
import OlchaUI
import OlchaCore
public class SavedTransactionsViewModel: BaseViewModel {
    @Published var savedTransactions: LoadingState<SavedTransactionsData, BaseErrorType> = .standart
    @Published var initialSavedTransactions: LoadingState<SavedTransactionsData, BaseErrorType> = .standart
    @Published var saveTransaction: LoadingState<EmptyData, BaseErrorType> = .standart
    @Published var deleteTransaction: LoadingState<EmptyData, BaseErrorType> = .standart
    @Published var savedTransaction: LoadingState<SavedTransactionData, BaseErrorType> = .standart
    
    private let saveTransactionUseCase: SaveTransactionProtocol
    private let editTransactionUseCase: EditSavedTransactionProtocol
    private let loadSavedTransactionsUseCase: LoadSavedTransactionsProtocol
    private let loadSavedTransactionUseCase: LoadSavedTransactionProtocol
    private let deleteTransactionUseCase: DeleteSavedTransactionProtocol
    
    public init(loadSavedTransactionUseCase: LoadSavedTransactionProtocol,
                loadSavedTransactionsUseCase: LoadSavedTransactionsProtocol,
                saveTransactionUseCase: SaveTransactionProtocol,
                deleteTransactionUseCase: DeleteSavedTransactionProtocol,
                editTransactionUseCase: EditSavedTransactionProtocol
    ) {
        self.loadSavedTransactionUseCase = loadSavedTransactionUseCase
        
        self.loadSavedTransactionsUseCase = loadSavedTransactionsUseCase
        
        self.saveTransactionUseCase = saveTransactionUseCase
        
        self.deleteTransactionUseCase = deleteTransactionUseCase
        
        self.editTransactionUseCase = editTransactionUseCase
    }
    
    func loadSavedTransaction(id: Int?, completed: ( () -> Void )? = nil) {
        savedTransaction = .loading
        
        guard let id = id else {
            savedTransaction = .failure(.init(message: "transaction_not_found".localized()))
            savedTransaction = .standart
            return
        }
        
        loadSavedTransactionUseCase.execute(id: id)
            .sink { [weak self] baseResponse in
                guard let self = self else { return }
                switch baseResponse.status {
                case .success:
                    self.savedTransaction = .success(baseResponse.response)
                    break
                default:
                    self.savedTransaction = .failure(.init(message: baseResponse.error))
                    break
                }
                self.savedTransaction = .standart
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    completed?()
                }
            }.store(in: &bag)
    }
    
    func loadSavedTransactions(page: Int) {
        savedTransactions = .loading
        loadSavedTransactionsUseCase.execute(page: page)
            .sink { [weak self] baseResponse in
                guard let self = self else { return }
                switch baseResponse.status {
                case .success:
                    self.savedTransactions = .success(baseResponse.response)
                    break
                default:
                    self.savedTransactions = .failure(.init(message: baseResponse.error))
                    break
                }
                savedTransactions = .standart
            }.store(in: &bag)
    }
    
    func loadInitialSavedTransactions() {
        initialSavedTransactions = .loading
        loadSavedTransactionsUseCase.execute(page: 1)
            .sink { [weak self] baseResponse in
                guard let self = self else { return }
                switch baseResponse.status {
                case .success:
                    
                    self.initialSavedTransactions = .success(baseResponse.response)
                    break
                default:
                    self.initialSavedTransactions = .failure(.init(message: baseResponse.error))
                    break
                }
                initialSavedTransactions = .standart
            }.store(in: &bag)
    }
    
    
    func saveTransaction(name: String, transaction: TransactionModel?) {
        saveTransaction = .loading
        saveTransactionUseCase.execute(request: getSaveTransactionRequest(name, transaction))
            .sink { [weak self] baseResponse in
                guard let self = self else { return }
                switch baseResponse.status {
                case .success:
                    self.saveTransaction = .success(baseResponse.response)
                    break
                default:
                    self.saveTransaction = .failure(.init(message: baseResponse.error))
                    break
                }
                self.saveTransaction = .standart
            }.store(in: &bag)
    }
    
    func editTransaction(id: Int, name: String, transaction: SavedTransactionModel?) {
        saveTransaction = .loading
        editTransactionUseCase.execute(id: id, request: getSaveTransactionRequest(name, transaction))
            .sink { [weak self] baseResponse in
                guard let self = self else { return }
                switch baseResponse.status {
                case .success:
                    self.saveTransaction = .success(baseResponse.response)
                    break
                default:
                    self.saveTransaction = .failure(.init(message: baseResponse.error))
                    break
                }
                self.saveTransaction = .standart
            }.store(in: &bag)
    }
    
    public func deleteTransaction(id: Int) {
        deleteTransaction = .loading
        deleteTransactionUseCase.execute(id: id)
            .sink { [weak self] baseResponse in
                guard let self = self else { return }
                switch baseResponse.status {
                case .success:
                    self.deleteTransaction = .success(baseResponse.response)
                    break
                default:
                    self.deleteTransaction = .failure(.init(message: baseResponse.error))
                    break
                }
                self.deleteTransaction = .standart
            }.store(in: &bag)
    }
    
    private func getSaveTransactionRequest(_ name: String, _ transaction: TransactionModel?) -> SaveTransactionRequest {
        return SaveTransactionRequest(name: name,
                                      provider_service_id: transaction?.provider_service?.id,
                                      service_price: transaction?.amount,
                                      fields: transaction?.fields)
    }
    
    private func getSaveTransactionRequest(_ name: String, _ transaction: SavedTransactionModel?) -> SaveTransactionRequest {
        return SaveTransactionRequest(name: name,
                                      provider_service_id: transaction?.provider_service?.id,
                                      service_price: transaction?.service_price,
                                      fields: transaction?.fields)
    }
}
