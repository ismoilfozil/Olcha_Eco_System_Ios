//
//  ProfitAssembly.swift
//  OlchaInvestCore
//
//  Created by Akhrorkhuja on 22/05/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import OlchaBilling
import Swinject

final class ProfitAssembly: Swinject.Assembly {

    func assemble(container: Container) {
        container.register(InvestProfitViewController.self) { resolver in
            let viewModel = resolver.resolve(ContractViewModel.self)!
            return InvestProfitViewController(viewModel: viewModel)
        }
        
        container.register(CardViewController.self) { resolver in
            let viewModel = resolver.resolve(InvestCardViewModel.self)!
            let billingViewModel: BillingViewModel = BillingDIContainer.shared.resolve()
            return CardViewController(viewModel: viewModel, billingViewModel: billingViewModel)
        }
        
        container.register(AutoWithdrawalViewController.self) { resolver in
            let viewModel = resolver.resolve(InvestCardViewModel.self)!
            let billingViewModel: BillingViewModel = BillingDIContainer.shared.resolve()
            return AutoWithdrawalViewController(viewModel: viewModel, billingViewModel: billingViewModel)
        }
    }
    
}
