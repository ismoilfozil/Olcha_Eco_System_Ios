//
//  BalanceAssembly.swift
//  OlchaNasiyaModule
//
//  Created by Elbek Khasanov on 11/07/23.
//

import UIKit
import OlchaBankCards
import OlchaCore

public class BankCardAssembly {
    static let shared = BankCardAssembly()
    
    func setupAssembly() {
        BankCardsDIContainer.shared.container.register(OlchaBankCards.VerifyBankCardPhoneProtocol.self) { (r, name: String?) in
            let repository: BankCardRepositoryProtocol = BankCardsDIContainer.shared.resolve(argument: name)
            guard name == String.billing else {
                return OlchaBankCards.BankCardUseCase.VerifyBankCardPhone(repository: repository)
            }
            return BillingUseCase.VerifyBillingBankCardPhone(repository: repository)
        }
        
        BankCardsDIContainer.shared.container.register(OlchaBankCards.UploadBankCardProtocol.self) { (r, name: String?) in
            let repository: BankCardRepositoryProtocol = BankCardsDIContainer.shared.resolve(argument: name)
            guard name == String.billing else {
                return OlchaBankCards.BankCardUseCase.UploadBankCard(repository: repository)
            }
            return BillingUseCase.UploadBillingBankCard(repository: repository)
        }
        
        BankCardsDIContainer.shared.container.register(OlchaBankCards.RemoveCardProtocol.self) { (r, name: String?) in
            let repository: BankCardRepositoryProtocol = BankCardsDIContainer.shared.resolve(argument: name)
            guard name == String.billing else {
                return OlchaBankCards.BankCardUseCase.RemoveCard(repository: repository)
            }
            return BillingUseCase.RemoveCard(repository: repository)
        }
        
        BankCardsDIContainer.shared.container.register(BankCardAPIProtocol.self) { (r, name: String?) in
            guard name == .billing else {
                return BankCardAPI()
            }
            return BillingBankCardAPI()
        }
//
//        BankCardsDIContainer.shared.container.register(LoadBankCardsProtocol.self) { (r, name: String?) in
//            let repository: BankCardRepositoryProtocol = BankCardsDIContainer.shared.resolve(argument: name)
//            
//            guard name == .billing else {
//                return BankCardUseCase.LoadBankCards(repository: repository)
//            }
//            
//            return BillingUseCase.LoadBillingBankCards(repository: repository)
//        }
        
    }
}
