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
import OlchaBankCards

final class UseCaseAssembly: Assembly {
    func assemble(container: Container) {
        
        container.register(LoadPaymentTypesProtocol.self) { (r) in
            let repository = r.resolve(BillingRepositoryProtocol.self)!
            return BillingUseCase.LoadPaymentTypes(repository: repository)
        }
        
        container.register(MakePaymentOtpProtocol.self) { (r) in
            let repository = r.resolve(BillingRepositoryProtocol.self)!
            return BillingUseCase.MakePaymentOtp(repository: repository)
        }
        
        container.register(MakePaymentProtocol.self) { (r) in
            let repository = r.resolve(BillingRepositoryProtocol.self)!
            return BillingUseCase.MakePayment(repository: repository)
        }
        
        container.register(GeneratePaymentLinkProtocol.self) { (r) in
            let repository = r.resolve(BillingRepositoryProtocol.self)!
            return BillingUseCase.GeneratePaymentLink(repository: repository)
        }
        
        container.register(LoadBillingEntitiesProtocol.self) { (r) in
            let repository = r.resolve(BillingRepositoryProtocol.self)!
            return BillingUseCase.LoadBillingEntities(repository: repository)
        }
        
        container.register(LoadBillingCurrencyProtocol.self) { (r) in
            let repository = r.resolve(BillingRepositoryProtocol.self)!
            return BillingUseCase.LoadBillingCurrency(repository: repository)
        }
    }
}
