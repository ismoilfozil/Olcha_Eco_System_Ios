//
//  TransactionRepository.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 28/03/23.
//

import Foundation
import Combine
import OlchaCore

public protocol TransactionRepositoryProtocol {
    func loadTransactionFeatures() -> AnyPublisher<(BaseResponse<TransactionsFeatures, EmptyData>), Never>
    
    func loadTransactions(filters: TransactionsFilters) -> AnyPublisher<(BaseResponse<TransactionsData, EmptyData>), Never>
    
    func loadTransaction(id: Int) -> AnyPublisher<(BaseResponse<TransactionData, EmptyData>), Never>
    
    func makeTransactionGetOtp(request: MakeTransactionGetOtpRequest) -> AnyPublisher<(BaseResponse<TransactionOtpData, EmptyData>), Never>
    
    func makeTransactionVerifyOtp(request: MakeTransactionVerifyOtpRequest) -> AnyPublisher<(BaseResponse<TransactionData, EmptyData>), Never>
}

public class TransactionRepository: BaseRepository, TransactionRepositoryProtocol {
    public func loadTransactionFeatures() -> AnyPublisher<(BaseResponse<TransactionsFeatures, EmptyData>), Never> {
        let api: TransactionAPI = .features
        return manager.request(api: api)
    }
    
    public func loadTransactions(filters: TransactionsFilters) -> AnyPublisher<(BaseResponse<TransactionsData, EmptyData>), Never> {
        let api: TransactionAPI = .transactions(filters: filters)
        return manager.request(api: api)
    }
    
    public func loadTransaction(id: Int) -> AnyPublisher<(BaseResponse<TransactionData, EmptyData>), Never> {
        let api: TransactionAPI = .transaction(id: id)
        return manager.request(api: api)
    }
    
    public func makeTransactionGetOtp(request: MakeTransactionGetOtpRequest) -> AnyPublisher<(BaseResponse<TransactionOtpData, EmptyData>), Never> {
        let api: TransactionAPI = .makeTransactionGetOtp(request: request)
        return manager.request(api: api)
    }
    
    public func makeTransactionVerifyOtp(request: MakeTransactionVerifyOtpRequest) -> AnyPublisher<(BaseResponse<TransactionData, EmptyData>),    Never> {
        let api: TransactionAPI = .makeTransactionVerifyOtp(request: request)
        return manager.request(api: api)
    }
}

public class MockTransactionRepository: BaseRepository, TransactionRepositoryProtocol {
    public func loadTransactionFeatures() -> AnyPublisher<(BaseResponse<TransactionsFeatures, EmptyData>), Never> {
        let api: TransactionAPI = .features
        return manager.request(api: api)
    }
    
    public func loadTransactions(filters: TransactionsFilters) -> AnyPublisher<(BaseResponse<TransactionsData, EmptyData>), Never> {
        let api: TransactionAPI = .transactions(filters: filters)
        return manager.request(api: api)
    }
    
    public func loadTransaction(id: Int) -> AnyPublisher<(BaseResponse<TransactionData, EmptyData>), Never> {
        let api: TransactionAPI = .transaction(id: id)
        return manager.request(api: api)
    }
    
    public func makeTransactionGetOtp(request: MakeTransactionGetOtpRequest) -> AnyPublisher<(BaseResponse<TransactionOtpData, EmptyData>), Never> {
        let api: TransactionAPI = .makeTransactionGetOtp(request: request)
        return Future { promise in
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                promise(.success(.init(status: .success,
                                       error: nil,
                                       response: .init(transaction: nil, transactions: nil),
                                       code: 200,
                                       errors: nil)))
            }
            
        }.eraseToAnyPublisher()
    }
    
    public func makeTransactionVerifyOtp(request: MakeTransactionVerifyOtpRequest) -> AnyPublisher<(BaseResponse<TransactionData, EmptyData>),    Never> {
        let api: TransactionAPI = .makeTransactionVerifyOtp(request: request)
        return Future { promise in
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                promise(.success(.init(status: .success,
                                       error: nil,
                                       response: .init(id: nil, transaction: .mock()),
                                       code: 200,
                                       errors: nil)))
            }
            
        }.eraseToAnyPublisher()
    }
}
