//
//  RepositoryAssembly.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 26/01/23.
//

import Foundation
import OlchaAuth
import Swinject
import OlchaCore
class RepositoryAssembly: Assembly {
    func assemble(container: Container) {
        container.register(BankCardsRepositoryProtocol.self) { r in
            let manager = r.resolve(NetworkManagerProtocol.self)!
            return BankCardsRepository(manager: manager)
        }
        
        container.register(CrudCardRepositoryProtocol.self) { r in
            let manager = r.resolve(NetworkManagerProtocol.self)!
            return CrudCardRepository(manager: manager)
        }
        
        container.register(NewsRepositoryProtocol.self) { r in
            let manager = r.resolve(NetworkManagerProtocol.self)!
            return NewsRepository(manager: manager)
        }
        
        container.register(NotificationsRepositoryProtocol.self) { r in
            let manager = r.resolve(NetworkManagerProtocol.self)!
            return NotificationsRepository(manager: manager)
        }
        
        container.register(PaymentsRepositoryProtocol.self) { r in
            let manager = r.resolve(NetworkManagerProtocol.self)!
            return PaymentsRepository(manager: manager)
        }
        
        container.register(TransactionRepositoryProtocol.self) { r in
            let manager = r.resolve(NetworkManagerProtocol.self)!
            return TransactionRepository(manager: manager)
        }
        
        container.register(SearchRepositoryProtocol.self) { r in
            let manager = r.resolve(NetworkManagerProtocol.self)!
            return SearchRepository(manager: manager)
        }
        
        container.register(SavedTransactionsRepositoryProtocol.self) { r in
            let manager = r.resolve(NetworkManagerProtocol.self)!
            return SavedTransactionsRepository(manager: manager)
        }
        
    }
}
