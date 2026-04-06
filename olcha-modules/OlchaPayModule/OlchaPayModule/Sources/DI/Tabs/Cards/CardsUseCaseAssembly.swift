//
//  CardsUseCaseAssembly.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 17/03/23.
//

import Foundation
import Swinject
final class CardsUseCaseAssembly: Assembly {
    func assemble(container: Container) {
        container.register(LoadBankCardsProtocol.self) { r in
            let repository = r.resolve(BankCardsRepositoryProtocol.self)!
            return BankCardsUseCase.LoadBankCards(bankCardsRepository: repository)
        }
        
        container.register(LoadBalancesProtocol.self) { r in
            let repository = r.resolve(BankCardsRepositoryProtocol.self)!
            return BankCardsUseCase.LoadBalances(bankCardsRepository: repository)
        }
        
        container.register(LoadBankCardsTransactionsProtocol.self) { r in
            let repository = r.resolve(BankCardsRepositoryProtocol.self)!
            return BankCardsUseCase.LoadTransactions(bankCardsRepository: repository)
        }
        
        container.register(AddCardOTPProtocol.self) { r in
            let repository = r.resolve(CrudCardRepositoryProtocol.self)!
            return CrudCardUseCase.AddCardOTP(crudCardRepository: repository)
        }
        
        container.register(RemoveCardProtocol.self) { r in
            let repository = r.resolve(CrudCardRepositoryProtocol.self)!
            return CrudCardUseCase.RemoveCard(crudCardRepository: repository)
        }
        
        container.register(VerifyOTPProtocol.self) { r in
            let repository = r.resolve(CrudCardRepositoryProtocol.self)!
            return CrudCardUseCase.VerifyOtp(crudCardRepository: repository)
        }
        
        container.register(UpdateCardProtocol.self) { r in
            let repository = r.resolve(CrudCardRepositoryProtocol.self)!
            return CrudCardUseCase.UpdateCard(crudCardRepository: repository)
        }
    }
}
