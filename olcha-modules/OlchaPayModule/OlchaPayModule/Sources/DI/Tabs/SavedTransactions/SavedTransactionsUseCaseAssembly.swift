//
//  SavedTransactionsUseCaseAssembly.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 05/04/23.
//

import Foundation
import Swinject
final class SavedTransactionsUseCaseAssembly: Assembly {
    func assemble(container: Container) {
        
        container.register(LoadSavedTransactionsProtocol.self) { r in
            let repository = r.resolve(SavedTransactionsRepositoryProtocol.self)!
            return SavedTransactionsUseCase.LoadSavedTransactions(repository: repository)
        }
        
        container.register(LoadSavedTransactionProtocol.self) { r in
            let repository = r.resolve(SavedTransactionsRepositoryProtocol.self)!
            return SavedTransactionsUseCase.LoadSavedTransaction(repository: repository)
        }
        
        container.register(SaveTransactionProtocol.self) { r in
            let repository = r.resolve(SavedTransactionsRepositoryProtocol.self)!
            return SavedTransactionsUseCase.SaveTransaction(repository: repository)
        }
        
        container.register(DeleteSavedTransactionProtocol.self) { r in
            let repository = r.resolve(SavedTransactionsRepositoryProtocol.self)!
            return SavedTransactionsUseCase.DeleteTransaction(repository: repository)
        }
        
        
        container.register(EditSavedTransactionProtocol.self) { r in
            let repository = r.resolve(SavedTransactionsRepositoryProtocol.self)!
            return SavedTransactionsUseCase.EditTransaction(repository: repository)
        }
        
        
        
        
    }
}
