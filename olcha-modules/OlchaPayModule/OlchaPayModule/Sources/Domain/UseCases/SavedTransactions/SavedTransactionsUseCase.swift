//
//  SavedTransactionsUseCase.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 05/04/23.
//

import Foundation
import Combine
import OlchaCore

public protocol DeleteSavedTransactionProtocol {
    func execute(id: Int) -> AnyPublisher<BaseResponse<EmptyData, EmptyData>, Never>
}

public protocol SaveTransactionProtocol {
    func execute(request: SaveTransactionRequest) -> AnyPublisher<BaseResponse<EmptyData, EmptyData>, Never>
}

public protocol EditSavedTransactionProtocol {
    func execute(id: Int, request: SaveTransactionRequest) -> AnyPublisher<BaseResponse<EmptyData, EmptyData>, Never>
}

public protocol LoadSavedTransactionsProtocol {
    func execute(page: Int) -> AnyPublisher<BaseResponse<SavedTransactionsData, EmptyData>, Never>
}

public protocol LoadSavedTransactionProtocol {
    func execute(id: Int) -> AnyPublisher<BaseResponse<SavedTransactionData, EmptyData>, Never>
}


public enum SavedTransactionsUseCase {
    
    public class LoadSavedTransactions: LoadSavedTransactionsProtocol {
        private let repository: SavedTransactionsRepositoryProtocol
        
        public init(repository: SavedTransactionsRepositoryProtocol) {
            self.repository = repository
        }
        
        public func execute(page: Int) -> AnyPublisher<BaseResponse<SavedTransactionsData, EmptyData>, Never> {
            repository.loadSavedTransactions(page: page)
        }
    }
    
    public class SaveTransaction: SaveTransactionProtocol {
        private let repository: SavedTransactionsRepositoryProtocol
        
        public init(repository: SavedTransactionsRepositoryProtocol) {
            self.repository = repository
        }
        
        public func execute(request: SaveTransactionRequest) -> AnyPublisher<BaseResponse<EmptyData, EmptyData>, Never> {
            repository.saveTransaction(request: request)
        }
    }
    
    public class EditTransaction: EditSavedTransactionProtocol {
        private let repository: SavedTransactionsRepositoryProtocol
        
        public init(repository: SavedTransactionsRepositoryProtocol) {
            self.repository = repository
        }
        
        public func execute(id: Int, request: SaveTransactionRequest) -> AnyPublisher<BaseResponse<EmptyData, EmptyData>, Never> {
            repository.editTransaction(id: id, request: request)
        }
    }
    
    public class DeleteTransaction: DeleteSavedTransactionProtocol {
        private let repository: SavedTransactionsRepositoryProtocol
        
        public init(repository: SavedTransactionsRepositoryProtocol) {
            self.repository = repository
        }
        
        public func execute(id: Int) -> AnyPublisher<BaseResponse<EmptyData, EmptyData>, Never> {
            repository.deleteTransaction(id: id)
        }
    }
    
    public class LoadSavedTransaction: LoadSavedTransactionProtocol {
        private let repository: SavedTransactionsRepositoryProtocol
        
        public init(repository: SavedTransactionsRepositoryProtocol) {
            self.repository = repository
        }
        
        public func execute(id: Int) -> AnyPublisher<BaseResponse<SavedTransactionData, EmptyData>, Never> {
            repository.loadSavedTransaction(id: id)
        }
    }
    
}

