//
//  NotificationAssembly.swift
//  OlchaInvestCore
//
//  Created by Akhrorkhuja on 29/05/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import Swinject
import OlchaCommon
import OlchaUtils

public final class NotificationAssembly: Assembly {

    public func assemble(container: Container) {
        container.register(NotificationViewController.self) { _ in
            let commonContainer = CommonDIContainer.shared
            let organization = Organization.invest
            let viewModel: CommonViewModel = commonContainer.resolve(argument: organization)
            return NotificationViewController(viewModel: viewModel)
        }
    }
    
}
