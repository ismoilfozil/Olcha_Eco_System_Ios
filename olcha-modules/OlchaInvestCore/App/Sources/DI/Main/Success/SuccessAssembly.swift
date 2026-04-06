//
//  SuccessAssembly.swift
//  OlchaInvestCore
//
//  Created by Akhrorkhuja on 23/05/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import Swinject

final class SuccessAssembly: Assembly {
    
    func assemble(container: Container) {
        container.register(SuccessViewController.self) { _ in
            return SuccessViewController()
        }
    }
    
}
