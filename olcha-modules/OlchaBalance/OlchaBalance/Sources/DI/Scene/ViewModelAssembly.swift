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
        container.register(BalanceViewModel.self) { (r, name: String?) in
            let loadBalanceUseCase = r.resolve(LoadBalanceProtocol.self, argument: name)!
            let loadPaymentTypesUseCase = r.resolve(LoadPaymentTypesProtocol.self, argument: name)!
            let makePaymentTransactionUseCase = r.resolve(MakePaymentTransactionProtocol.self, argument: name)!
            let makePaymentTransactionOTPUseCase = r.resolve(MakePaymentTransactionOTPProtocol.self, argument: name)!
            let generateLinkUseCase = r.resolve(GenerateLinkProtocol.self, argument: name)!
            return BalanceViewModel(loadBalanceUseCase: loadBalanceUseCase,
                                    loadPaymentTypesUseCase: loadPaymentTypesUseCase,
                                    makePaymentTransactionUseCase: makePaymentTransactionUseCase,
                                    makePaymentTransactionOTPUseCase: makePaymentTransactionOTPUseCase,
                                    generateLinkUseCase: generateLinkUseCase)
        }
    }
}
