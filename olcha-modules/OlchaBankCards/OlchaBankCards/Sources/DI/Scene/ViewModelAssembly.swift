//
//  OlchaBankCardsViewAssembly.swift
//  OlchaBankCards
//
//  Created by Elbek Khasanov on 22/05/23.
//


import Foundation
import Swinject
final class ViewModelAssembly: Assembly {
    public func assemble(container: Container) {
        container.register(BankCardViewModel.self) { (r, name: String?) in
            let verifyBankCardPhoneUseCase = r.resolve(VerifyBankCardPhoneProtocol.self, argument: name)!
            let uploadBankCardUseCase = r.resolve(UploadBankCardProtocol.self, argument: name)!
            let loadBankCardsUseCase = r.resolve(LoadBankCardsProtocol.self, argument: name)!
            let makeDefaultUseCase = r.resolve(MakeDefaultProtocol.self, argument: name)!
            let removeCardUseCase = r.resolve(RemoveCardProtocol.self, argument: name)!

            return BankCardViewModel(
                verifyBankCardPhoneUseCase: verifyBankCardPhoneUseCase,
                uploadBankCardUseCase: uploadBankCardUseCase,
                loadBankCardsUseCase: loadBankCardsUseCase,
                makeDefaultUseCase: makeDefaultUseCase,
                removeCardUseCase: removeCardUseCase
            )
        }
        
        
        
    }
}
