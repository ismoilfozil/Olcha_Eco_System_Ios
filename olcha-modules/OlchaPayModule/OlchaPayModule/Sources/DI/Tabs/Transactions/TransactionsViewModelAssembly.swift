//
//  TransactionsViewModelAssembly.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 28/03/23.
//


import Foundation
import Swinject
final class TransactionsViewModelAssembly: Assembly {
    func assemble(container: Container) {
        container.register(TransactionViewModel.self, name: .shared) { r in
            let loadTransactionsUseCase = r.resolve(LoadTransactionsProtocol.self)!
            let loadTransactionsFeaturesUseCase = r.resolve(LoadTransactionsFeaturesProtocol.self)!
            let loadTransactionUseCase = r.resolve(LoadTransactionProtocol.self)!
            
            return TransactionViewModel(
                loadTransactionsUseCase: loadTransactionsUseCase,
                loadTransactionsFeaturesUseCase: loadTransactionsFeaturesUseCase,
                loadTransactionUseCase: loadTransactionUseCase
            )
        }.inObjectScope(.container)
        
        container.register(TransactionViewModel.self) { r in
            let loadTransactionsUseCase = r.resolve(LoadTransactionsProtocol.self)!
            let loadTransactionsFeaturesUseCase = r.resolve(LoadTransactionsFeaturesProtocol.self)!
            let loadTransactionUseCase = r.resolve(LoadTransactionProtocol.self)!
            
            return TransactionViewModel(
                loadTransactionsUseCase: loadTransactionsUseCase,
                loadTransactionsFeaturesUseCase: loadTransactionsFeaturesUseCase,
                loadTransactionUseCase: loadTransactionUseCase)
            
        }
        
        container.register(MakeTransactionViewModel.self) { r in
            let makeTransactionGetOtpUseCase = r.resolve(MakeTransactionGetOtpProtocol.self)!
            let makeTransactionVerifyOtpUseCase = r.resolve(MakeTransactionVerifyOtpProtocol.self)!
            
            return MakeTransactionViewModel(
                makeTransactionGetOtpUseCase: makeTransactionGetOtpUseCase,
                makeTransactionVerifyOtpUseCase: makeTransactionVerifyOtpUseCase)
        }
    }
    
}
