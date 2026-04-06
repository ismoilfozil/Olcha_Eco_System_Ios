//
//  InvestAssembly.swift
//  OlchaInvestCore
//
//  Created by Akhrorkhuja on 25/05/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import Swinject

public final class InvestAssembly: Swinject.Assembly {
    
    public func assemble(container: Swinject.Container) {
        container.register(InvestViewModel.self) { resolver in
            let storeContractUseCase = resolver.resolve(StoreContractProtocol.self)!
            return InvestViewModel(storeContractUseCase: storeContractUseCase)
        }
        
        container.register(InvestViewController.self) { resolver in
            let viewModel = resolver.resolve(InvestViewModel.self)!
            return InvestViewController(viewModel: viewModel)
        }
        
        container.register(SelectPackageViewController.self) { resolver in
            let viewModel = resolver.resolve(PackagesViewModel.self)!
            return SelectPackageViewController(viewModel: viewModel)
        }
        
        container.register(SelectTermViewModel.self) { resolver in
            let laodTermsUseCase = resolver.resolve(LoadTermsProtocol.self)!
            return SelectTermViewModel(loadTermsUseCase: laodTermsUseCase)
        }
        
        container.register(SelectTermViewController.self) { resolver in
            let viewModel = resolver.resolve(SelectTermViewModel.self)!
            return SelectTermViewController(viewModel: viewModel)
        }
        
        container.register(AmountViewController.self) { _ in
            return AmountViewController()
        }
    }
    
}
