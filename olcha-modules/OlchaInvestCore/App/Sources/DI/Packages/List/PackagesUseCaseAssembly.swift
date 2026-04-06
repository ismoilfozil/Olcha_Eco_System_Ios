//
//  PackagesUseCaseAssembly.swift
//  OlchaInvestCore
//
//  Created by Akhrorkhuja on 24/05/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import Swinject

final class PackagesUseCaseAssembly: Assembly {
    
    func assemble(container: Container) {
        container.register(LoadPackagesProtocol.self) { resolver in
            let repository = resolver.resolve(InvestPackagesRepositoryProtocol.self)!
            return PackagesUseCase.LoadPackages(repository: repository)
        }
        
        container.register(LoadPackageProtocol.self) { resolver in
            let repository = resolver.resolve(InvestPackagesRepositoryProtocol.self)!
            return PackagesUseCase.LoadPackage(repository: repository)
        }
    }
    
}
