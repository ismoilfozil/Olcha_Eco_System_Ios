//
//  PackagesAssembly.swift
//  OlchaInvestCore
//
//  Created by Akhrorkhuja on 23/05/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import Swinject

final class PackagesAssembly: Assembly {
    
    func assemble(container: Container) {
        container.register(PackagesViewModel.self) { resolver in
            let loadPackagesUseCase = resolver.resolve(LoadPackagesProtocol.self)!
            let loadPackageUseCase = resolver.resolve(LoadPackageProtocol.self)!
            return PackagesViewModel(loadPackagesUseCase: loadPackagesUseCase, loadPackageUseCase: loadPackageUseCase)
        }
        
        container.register(PackagesViewController.self) { resolver in
            let viewModel = resolver.resolve(PackagesViewModel.self)!
            return PackagesViewController(viewModel: viewModel)
        }
        
        container.register(PackagesDetailViewController.self) { resolver in
            let viewModel = resolver.resolve(PackagesViewModel.self)!
            return PackagesDetailViewController(viewModel: viewModel)
        }
    }
    
}
