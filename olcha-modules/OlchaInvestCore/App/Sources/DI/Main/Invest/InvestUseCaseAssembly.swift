//
//  InvestUseCaseAssembly.swift
//  OlchaInvestCore
//
//  Created by Akhrorkhuja on 26/05/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import Swinject

public final class InvestUseCaseAssembly: Assembly {
    
    public func assemble(container: Container) {
        container.register(LoadTermsProtocol.self) { resolver in
            let repository = resolver.resolve(InvestPackagesRepositoryProtocol.self)!
            return TermsUseCase.LoadTerms(repository: repository)
        }
    }
    
}
