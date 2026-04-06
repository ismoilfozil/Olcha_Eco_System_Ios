//
//  SavedTransactionsViewModelAssembly.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 05/04/23.
//


import Foundation
import Swinject
final class SavedTransactionsViewModelAssembly: Assembly {
    func assemble(container: Container) {
        container.register(SavedTransactionsViewModel.self, name: "shared") { r in
            let saveTransactionUseCase = r.resolve(SaveTransactionProtocol.self)!
            let loadSavedTransactionsUseCase = r.resolve(LoadSavedTransactionsProtocol.self)!
            let loadSavedTransactionUseCase = r.resolve(LoadSavedTransactionProtocol.self)!
            let deleteSavedTransactionsUseCase = r.resolve(DeleteSavedTransactionProtocol.self)!
            let editSavedTransactionsUseCase = r.resolve(EditSavedTransactionProtocol.self)!
            
            return SavedTransactionsViewModel(
                loadSavedTransactionUseCase: loadSavedTransactionUseCase,
                loadSavedTransactionsUseCase: loadSavedTransactionsUseCase,
                saveTransactionUseCase: saveTransactionUseCase,
                deleteTransactionUseCase: deleteSavedTransactionsUseCase,
                editTransactionUseCase: editSavedTransactionsUseCase)
        }.inObjectScope(.container)
        
        container.register(SavedTransactionsViewModel.self) { r in
            let saveTransactionUseCase = r.resolve(SaveTransactionProtocol.self)!
            let loadSavedTransactionsUseCase = r.resolve(LoadSavedTransactionsProtocol.self)!
            let loadSavedTransactionUseCase = r.resolve(LoadSavedTransactionProtocol.self)!
            let deleteSavedTransactionsUseCase = r.resolve(DeleteSavedTransactionProtocol.self)!
            let editSavedTransactionsUseCase = r.resolve(EditSavedTransactionProtocol.self)!
            
            return SavedTransactionsViewModel(
                loadSavedTransactionUseCase: loadSavedTransactionUseCase,
                loadSavedTransactionsUseCase: loadSavedTransactionsUseCase,
                saveTransactionUseCase: saveTransactionUseCase,
                deleteTransactionUseCase: deleteSavedTransactionsUseCase,
                editTransactionUseCase: editSavedTransactionsUseCase)
            
        }
    }
    
}
