//
//  RepositoryAssembly.swift
//  OlchaBankCards
//
//  Created by Elbek Khasanov on 22/06/23.
//

import Foundation
import Swinject
final class UseCaseAssembly: Assembly {
    public func assemble(container: Container) {
        
        container.register(VerifyBankCardPhoneProtocol.self) { (r, name: String?) in
            let repository = r.resolve(BankCardRepositoryProtocol.self, argument: name)!
            return BankCardUseCase.VerifyBankCardPhone(repository: repository)
        }

        container.register(UploadBankCardProtocol.self) { (r, name: String?) in
            let repository = r.resolve(BankCardRepositoryProtocol.self, argument: name)!
            return BankCardUseCase.UploadBankCard(repository: repository)
        }

        container.register(LoadBankCardsProtocol.self) { (r, name: String?) in
            let repository = r.resolve(BankCardRepositoryProtocol.self, argument: name)!
            return BankCardUseCase.LoadBankCards(repository: repository)
        }

        container.register(MakeDefaultProtocol.self) { (r, name: String?) in
            let repository = r.resolve(BankCardRepositoryProtocol.self, argument: name)!
            return BankCardUseCase.MakeDefault(repository: repository)
        }

        container.register(RemoveCardProtocol.self) { (r, name: String?) in
            let repository = r.resolve(BankCardRepositoryProtocol.self, argument: name)!
            return BankCardUseCase.RemoveCard(repository: repository)
        }
        
        
    }
}
