//
//  FaqAssembly.swift
//  OlchaInvestCore
//
//  Created by Akhrorkhuja on 30/05/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import Swinject
import OlchaCommon
import OlchaUtils

public final class FaqAssembly: Assembly {
    
    public func assemble(container: Container) {
        container.register(FaqViewController.self) { resolver in
            let commonContainer = CommonDIContainer.shared
            let organization = Organization.invest
            let viewModel: CommonViewModel = commonContainer.resolve(argument: organization)
            return FaqViewController(viewModel: viewModel)
        }
    }
    
}
