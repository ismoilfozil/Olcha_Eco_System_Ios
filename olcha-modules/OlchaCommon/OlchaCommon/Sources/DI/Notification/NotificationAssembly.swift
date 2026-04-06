//
//  NotificationAssembly.swift
//  OlchaInvestCore
//
//  Created by Akhrorkhuja on 29/05/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import Swinject
import OlchaUtils

public final class NotificationAssembly: Assembly {

    public func assemble(container: Container) {
        container.register(NotificationViewController.self) { (r, organization: Organization) in
            let viewModel = r.resolve(CommonViewModel.self, argument: organization)!
            return MainActor.assumeIsolated { NotificationViewController(viewModel: viewModel) }
        }
        container.register(NotificationDetailViewController.self) { (r) in
            MainActor.assumeIsolated { NotificationDetailViewController() }
        }
    }

}
