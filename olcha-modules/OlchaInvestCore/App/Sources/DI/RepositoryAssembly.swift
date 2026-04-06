//
//  RepositoryAssembly.swift
//  OlchaInvestCore
//
//  Created by Akhrorkhuja on 17/05/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import Swinject
import OlchaCore

final class RepositoryAssembly: Swinject.Assembly {
    
    public func assemble(container: Swinject.Container) {
        container.register(InvestHomeRepositoryProtocol.self) { resolver in
            let manager = resolver.resolve(NetworkManagerProtocol.self)!
            return InvestHomeRepository(manager: manager)
        }
        
        container.register(InvestProfitRepositoryProtocol.self) { resolver in
            let manager = resolver.resolve(NetworkManagerProtocol.self)!
            return InvestProfitRepository(manager: manager)
        }
        
        container.register(InvestCardRepositoryProtocol.self) { resolver in
            let manager = resolver.resolve(NetworkManagerProtocol.self)!
            return InvestCardRepository(manager: manager)
        }
        
        container.register(InvestPackagesRepositoryProtocol.self) { resolver in
            let manager = resolver.resolve(NetworkManagerProtocol.self)!
            return InvestPackagesRepository(manager: manager)
        }
        
        container.register(HelpRepositoryProtocol.self) { resolver in
            let manager = resolver.resolve(NetworkManagerProtocol.self)!
            return HelpRepository(manager: manager)
        }
        
        container.register(SuggestionRepositoryProtocol.self) { resolver in
            let manager = resolver.resolve(NetworkManagerProtocol.self)!
            return SuggestionRepository(manager: manager)
        }
    }
    
}
