//
//  BalanceAssembly.swift
//  OlchaNasiyaModule
//
//  Created by Elbek Khasanov on 11/07/23.
//

import UIKit
import OlchaBankCards
import OlchaCore

public class BalanceAssembly {
    static let shared = BalanceAssembly()
    
    func setupAssembly() {
//        BalanceDIContainer.shared.container.register(OlchaBalance.LoadPaymentTypesProtocol.self) { (r, name: String?) in
//            guard name == String.billing else {
//                let repository: BalanceRepositoryProtocol = BalanceDIContainer.shared.resolve(argument: name)
//                return BalanceUseCase.LoadPaymentTypes(repository: repository)
//            }
//
//            let repository: BankCardRepositoryProtocol = BankCardsDIContainer.shared.resolve(argument: name)
//            let loadPaymentTypesUseCase: OlchaBilling.LoadPaymentTypesProtocol = BillingDIContainer.shared.resolve()
//
//            return BillingUseCase.LoadBillingPayments(repository: repository,
//                                                      loadPaymentTypesUseCase: loadPaymentTypesUseCase)
//        }
//
//        BalanceDIContainer.shared.container.register(GenerateLinkProtocol.self) { (r, name: String?) in
//            guard name == String.billing else {
//                let repository: BalanceRepositoryProtocol = BalanceDIContainer.shared.resolve(argument: name)
//                return BalanceUseCase.GenerateLink(repository: repository)
//            }
//            let repository: BillingRepositoryProtocol = BillingDIContainer.shared.resolve()
//            return BillingUseCase.GenerateBillingLink(repository: repository)
//        }
//
//        BalanceDIContainer.shared.container.register(OlchaBalance.MakePaymentTransactionProtocol.self) { (r, name: String?) in
//            guard name == String.billing else {
//                let repository: BalanceRepositoryProtocol = BalanceDIContainer.shared.resolve(argument: name)
//                return BalanceUseCase.MakePaymentTransaction(repository: repository)
//            }
//            let repository: BillingRepositoryProtocol = BillingDIContainer.shared.resolve()
//            let loadBillingBalancesUseCase: OlchaBalance.LoadBalanceProtocol = BalanceDIContainer.shared.resolve(argument: name)
//            return BillingUseCase.MakeBillingPaymentTransactionProtocol(
//                repository: repository,
//                loadBillingBalancesUseCase: loadBillingBalancesUseCase
//            )
//        }
//
//        BalanceDIContainer.shared.container.register(OlchaBalance.MakePaymentTransactionOTPProtocol.self) { (r, name: String?) in
//            guard name == String.billing else {
//                let repository: BalanceRepositoryProtocol = BalanceDIContainer.shared.resolve(argument: name)
//                return BalanceUseCase.MakePaymentTransactionOTP(repository: repository)
//            }
//            let repository: BillingRepositoryProtocol = BillingDIContainer.shared.resolve()
//            let loadBillingBalancesUseCase: OlchaBalance.LoadBalanceProtocol = BalanceDIContainer.shared.resolve(argument: name)
//            return BillingUseCase.MakeBillingPaymentOTPTransactionProtocol(
//                repository: repository,
//                loadBillingBalancesUseCase: loadBillingBalancesUseCase
//            )
//        }
//
//        BalanceDIContainer.shared.container.register(LoadBalanceProtocol.self) { (r, name: String?) in
//
//            guard name == .billing else {
//                let repository: BalanceRepositoryProtocol = BalanceDIContainer.shared.resolve(argument: name)
//                return BalanceUseCase.LoadBalance(repository: repository)
//            }
//
//            let repository: BankCardRepositoryProtocol = BankCardsDIContainer.shared.resolve(argument: name)
//
//            return BillingUseCase.LoadBillingBalances(repository: repository)
//
//        }
    }
}
