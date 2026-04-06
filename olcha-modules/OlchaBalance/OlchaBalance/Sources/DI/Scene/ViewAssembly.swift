//
//  OlchaBankCardsViewAssembly.swift
//  OlchaBankCards
//
//  Created by Elbek Khasanov on 22/05/23.
//


import Foundation
import Swinject
import OlchaBankCards
final class ViewAssembly: Assembly {
    public func assemble(container: Container) {
        
        container.register(BalanceCardsPage.self) { (r, name: String?) in
            return BalanceCardsPage()
        }
        
        container.register(BalanceFillPage.self) { (r, name: String?) in
            let viewModel = r.resolve(BalanceViewModel.self, argument: name)!
            return BalanceFillPage(viewModel: viewModel)
        }
        
        container.register(BalanceCardsPage.self) { (r, name: String?) in
            let viewModel: BankCardViewModel = BankCardsDIContainer.shared.resolve(argument: name)
            return BalanceCardsPage(viewModel: viewModel)
        }
        
        container.register(EnterPaymentCardPage.self) { (r, name: String?) in
            let viewModel = r.resolve(BalanceViewModel.self, argument: name)!
            return EnterPaymentCardPage(viewModel: viewModel)
        }
        
        container.register(EnterPaymentPage.self) { (r, name: String?) in
            let viewModel = r.resolve(BalanceViewModel.self, argument: name)!
            return EnterPaymentPage(viewModel: viewModel)
        }
        
        container.register(BalanceWebPage.self) { (r, name: String?) in
            return BalanceWebPage()
        }
        
    }
}
