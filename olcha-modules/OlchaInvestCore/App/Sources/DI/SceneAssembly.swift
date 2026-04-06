//
//  SceneAssembly.swift
//  OlchaInvestCore
//
//  Created by Akhrorkhuja on 17/05/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import Swinject

final class SceneAssembly: Swinject.Assembly {
    
    public func assemble(container: Swinject.Container) {
        let assemblies: [Swinject.Assembly] = [
            OnboardingAssembly(),
            HomeAssembly(),
            ProfitAssembly(),
            CardAssembly(),
            SuccessAssembly(),
            PackagesAssembly(),
            InvestAssembly(),
            NotificationAssembly(),
            FaqAssembly(),
            ProfileAssembly(),
            HelpAssembly(),
        ]
        assemblies.forEach({ $0.assemble(container: container) })
    }
    
}

