//
//  TransactionsUseCaseAssembly.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 28/03/23.
//

import Foundation
import Swinject
final class TransactionsUseCaseAssembly: Assembly {
    func assemble(container: Container) {
        container.register(LoadTransactionsProtocol.self) { r in
            let repository = r.resolve(TransactionRepositoryProtocol.self)!
            return TransactionUseCase.LoadTransactions(repository: repository)
        }
        
        container.register(LoadTransactionsFeaturesProtocol.self) { r in
            let repository = r.resolve(TransactionRepositoryProtocol.self)!
            return TransactionUseCase.LoadTransactionsFeatures(repository: repository)
        }
        
        container.register(LoadTransactionProtocol.self) { r in
            let repository = r.resolve(TransactionRepositoryProtocol.self)!
            return TransactionUseCase.LoadTransaction(repository: repository)
        }
        
        container.register(MakeTransactionGetOtpProtocol.self) { r in
            let repository = r.resolve(TransactionRepositoryProtocol.self)!
            return TransactionUseCase.MakeTransactionGetOtp(repository: repository)
        }
        
        container.register(MakeTransactionVerifyOtpProtocol.self) { r in
            let repository = r.resolve(TransactionRepositoryProtocol.self)!
            return TransactionUseCase.MakeTransactionVerifyOtp(repository: repository)
        }
    }
}
