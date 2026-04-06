//
//  TransactionsUseCase.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 28/03/23.
//

import Foundation
import Combine
import OlchaCore

public protocol LoadTransactionsProtocol {
    func execute(filters: TransactionsFilters) -> AnyPublisher<BaseResponse<TransactionsData, EmptyData>, Never>
}

public protocol LoadTransactionsFeaturesProtocol {
    func execute() -> AnyPublisher<BaseResponse<TransactionsFeatures, EmptyData>, Never>
}

public protocol LoadTransactionProtocol {
    func execute(id: Int) -> AnyPublisher<BaseResponse<TransactionData, EmptyData>, Never>
}

public protocol MakeTransactionGetOtpProtocol {
    func execute(request: MakeTransactionGetOtpRequest) -> AnyPublisher<BaseResponse<TransactionOtpData, EmptyData>, Never>
}

public protocol MakeTransactionVerifyOtpProtocol {
    func execute(request: MakeTransactionVerifyOtpRequest) -> AnyPublisher<BaseResponse<TransactionData, EmptyData>, Never>
}
public enum TransactionUseCase {
    public class LoadTransactions: LoadTransactionsProtocol {
        private let repository: TransactionRepositoryProtocol
        
        public init(repository: TransactionRepositoryProtocol) {
            self.repository = repository
        }
        
        public func execute(filters: TransactionsFilters) -> AnyPublisher<BaseResponse<TransactionsData, EmptyData>, Never> {
            repository.loadTransactions(filters: filters)
        }
    }
    
    public class LoadTransactionsFeatures: LoadTransactionsFeaturesProtocol {
        private let repository: TransactionRepositoryProtocol
        
        public init(repository: TransactionRepositoryProtocol) {
            self.repository = repository
        }
        
        public func execute() -> AnyPublisher<BaseResponse<TransactionsFeatures, EmptyData>, Never> {
            repository.loadTransactionFeatures()
        }
    }
    
    public class LoadTransaction: LoadTransactionProtocol {
        private let repository: TransactionRepositoryProtocol
        
        public init(repository: TransactionRepositoryProtocol) {
            self.repository = repository
        }
        
        public func execute(id: Int) -> AnyPublisher<BaseResponse<TransactionData, EmptyData>, Never> {
            repository.loadTransaction(id: id)
        }
    }
    
    public class MakeTransactionGetOtp: MakeTransactionGetOtpProtocol {
        private let repository: TransactionRepositoryProtocol
        
        public init(repository: TransactionRepositoryProtocol) {
            self.repository = repository
        }
        
        public func execute(request: MakeTransactionGetOtpRequest) -> AnyPublisher<BaseResponse<TransactionOtpData, EmptyData>, Never> {
            repository.makeTransactionGetOtp(request: request)
        }
    }
    
    public class MakeTransactionVerifyOtp: MakeTransactionVerifyOtpProtocol {
        private let repository: TransactionRepositoryProtocol
        
        public init(repository: TransactionRepositoryProtocol) {
            self.repository = repository
        }
        
        public func execute(request: MakeTransactionVerifyOtpRequest) -> AnyPublisher<BaseResponse<TransactionData, EmptyData>, Never> {
            repository.makeTransactionVerifyOtp(request: request)
        }
    }
}
