//
//  SavedTransactionsRepository.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 05/04/23.
//
import Foundation
import Combine
import OlchaCore

public protocol SavedTransactionsRepositoryProtocol {

    func loadSavedTransactions(page: Int) -> AnyPublisher<(BaseResponse<SavedTransactionsData, EmptyData>), Never>
    
    func loadSavedTransaction(id: Int) -> AnyPublisher<(BaseResponse<SavedTransactionData, EmptyData>), Never>
    
    func saveTransaction(request: SaveTransactionRequest) -> AnyPublisher<(BaseResponse<EmptyData, EmptyData>), Never>
    
    func editTransaction(id: Int, request: SaveTransactionRequest) -> AnyPublisher<(BaseResponse<EmptyData, EmptyData>), Never>
    
    func deleteTransaction(id: Int) -> AnyPublisher<(BaseResponse<EmptyData, EmptyData>), Never>
    
}

public class SavedTransactionsRepository: BaseRepository, SavedTransactionsRepositoryProtocol {
    
    public func loadSavedTransactions(page: Int) -> AnyPublisher<(BaseResponse<SavedTransactionsData, EmptyData>), Never> {
        let api: SavedTransactionsAPI = .savedTransactions(page: page)
        return manager.request(api: api,
                               isSingleRequest: false,
                               isCancellable: false)
    }
    
    public func saveTransaction(request: SaveTransactionRequest) -> AnyPublisher<(BaseResponse<EmptyData, EmptyData>), Never> {
        let api: SavedTransactionsAPI = .saveTransaction(request: request)
        return manager.request(api: api,
                               isSingleRequest: false,
                               isCancellable: false)
    }
    
    public func editTransaction(id: Int, request: SaveTransactionRequest) -> AnyPublisher<(BaseResponse<EmptyData, EmptyData>), Never> {
        let api: SavedTransactionsAPI = .editTransaction(id: id, request: request)
        return manager.request(api: api,
                               isSingleRequest: false,
                               isCancellable: false)
    }
    
    public func deleteTransaction(id: Int) -> AnyPublisher<(BaseResponse<EmptyData, EmptyData>), Never> {
        let api: SavedTransactionsAPI = .deleteTransaction(id: id)
        return manager.request(api: api,
                               isSingleRequest: false,
                               isCancellable: false)
    }
    
    public func loadSavedTransaction(id: Int) -> AnyPublisher<(BaseResponse<SavedTransactionData, EmptyData>), Never> {
        let api: SavedTransactionsAPI = .savedTransaction(id: id)
        return manager.request(api: api,
                               isSingleRequest: false,
                               isCancellable: false)
    }
    
}
