//
//  UseCaseAssembly.swift
//  OlchaInvestCore
//
//  Created by Akhrorkhuja on 17/05/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import Swinject

final class UseCaseAssembly: Swinject.Assembly {
    
    public func assemble(container: Swinject.Container) {
        let assemblies: [Assembly] = [
            HomeUseCaseAssembly(),
            CardUseCaseAssembly(),
            PackagesUseCaseAssembly(),
            InvestUseCaseAssembly(),
            ProfitUseCaseAssembly(),
            HelpUseCaseAssembly(),
        ]
        assemblies.forEach({ $0.assemble(container: container) })
    }
    
}
