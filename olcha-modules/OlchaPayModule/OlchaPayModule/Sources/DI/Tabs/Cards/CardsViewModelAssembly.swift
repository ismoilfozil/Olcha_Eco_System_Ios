//
//  CardsViewModelAssembly.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 16/03/23.
//

import Foundation
import Swinject
final class CardsViewModelAssembly: Assembly {
    func assemble(container: Container) {
        container.register(BankCardsViewModel.self) { r in
            let loadBankCardsUseCase = r.resolve(LoadBankCardsProtocol.self)!

            let loadBalancesUseCase = r.resolve(LoadBalancesProtocol.self)!
            
            let loadBankCardsTransactionsUseCase = r.resolve(LoadBankCardsTransactionsProtocol.self)!
            
            return BankCardsViewModel(
                loadBankCardsUseCase: loadBankCardsUseCase,
                loadBalancesUseCase: loadBalancesUseCase,
                loadBankCardsTransactionsUseCase: loadBankCardsTransactionsUseCase
            )
        }
        
        container.register(BankCardsViewModel.self, name: "shared") { r in
            let loadBankCardsUseCase = r.resolve(LoadBankCardsProtocol.self)!

            let loadBalancesUseCase = r.resolve(LoadBalancesProtocol.self)!
            
            let loadBankCardsTransactionsUseCase = r.resolve(LoadBankCardsTransactionsProtocol.self)!
            
            return BankCardsViewModel(
                loadBankCardsUseCase: loadBankCardsUseCase,
                loadBalancesUseCase: loadBalancesUseCase,
                loadBankCardsTransactionsUseCase: loadBankCardsTransactionsUseCase
            )
            
        }.inObjectScope(.container)
        
        container.register(CrudCardViewModel.self, name: .shared) { r in
            let addCardOTPUseCase = r.resolve(AddCardOTPProtocol.self)!
            let verifyOTPUseCase = r.resolve(VerifyOTPProtocol.self)!
            let removeCardUseCase = r.resolve(RemoveCardProtocol.self)!
            let updateCardUseCase = r.resolve(UpdateCardProtocol.self)!
            
            return CrudCardViewModel(addCardOTPUseCase: addCardOTPUseCase,
                                     verifyOTPUseCase: verifyOTPUseCase,
                                     removeCardUseCase: removeCardUseCase,
                                     updateCardUseCase: updateCardUseCase
            )
        }.inObjectScope(.container)
    }
}
