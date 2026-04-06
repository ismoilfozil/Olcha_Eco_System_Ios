//
//  ViewAssembly.swift
//  OlchaAuth
//
//  Created by Elbek Khasanov on 26/05/23.
//

import Foundation
import Swinject
import OlchaUI
import OlchaUtils

final class ViewModelAssembly: Assembly {
    func assemble(container: Container) {
        container.register(BillingViewModel.self) { (r) in
            let loadPaymentTypesUseCase = r.resolve(LoadPaymentTypesProtocol.self)!
            let makePaymentOtpUseCase = r.resolve(MakePaymentOtpProtocol.self)!
            let makePaymentUseCase = r.resolve(MakePaymentProtocol.self)!
            let generatePaymentLinkUseCase = r.resolve(GeneratePaymentLinkProtocol.self)!
            let loadBillingEntitiesUseCase = r.resolve(LoadBillingEntitiesProtocol.self)!
            let loadBillingCurrencyUseCase = r.resolve(LoadBillingCurrencyProtocol.self)!
            
            return BillingViewModel(loadPaymentTypesUseCase: loadPaymentTypesUseCase,
                                    makePaymentOtpUseCase: makePaymentOtpUseCase,
                                    makePaymentUseCase: makePaymentUseCase,
                                    generatePaymentLinkUseCase: generatePaymentLinkUseCase,
                                    loadBillingEntitiesUseCase: loadBillingEntitiesUseCase,
                                    loadCurrencyUseCase: loadBillingCurrencyUseCase)
        }
    }
}
