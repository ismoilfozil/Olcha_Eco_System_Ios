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
        
        container.register(LoadBalanceProtocol.self) { (r, name: String?) in
            let repository = r.resolve(BalanceRepositoryProtocol.self, argument: name)!
            return BalanceUseCase.LoadBalance(repository: repository)
        }

        container.register(LoadPaymentTypesProtocol.self) { (r, name: String?) in
            let repository = r.resolve(BalanceRepositoryProtocol.self, argument: name)!
            return BalanceUseCase.LoadPaymentTypes(repository: repository)
        }

        container.register(MakePaymentTransactionProtocol.self) { (r, name: String?) in
            let repository = r.resolve(BalanceRepositoryProtocol.self, argument: name)!
            return BalanceUseCase.MakePaymentTransaction(repository: repository)
        }

        container.register(MakePaymentTransactionOTPProtocol.self) { (r, name: String?) in
            let repository = r.resolve(BalanceRepositoryProtocol.self, argument: name)!
            return BalanceUseCase.MakePaymentTransactionOTP(repository: repository)
        }
        
        container.register(GenerateLinkProtocol.self) { (r, name: String?) in
            let repository = r.resolve(BalanceRepositoryProtocol.self, argument: name)!
            return BalanceUseCase.GenerateLink(repository: repository)
        }
        
    }
}
