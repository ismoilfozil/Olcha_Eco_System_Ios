//
//  ManagerAssembly.swift
//  OlchaBilling
//
//  Created by Elbek Khasanov on 21/06/23.
//

import Swinject
import OlchaUI
import UIKit

final class CoordinatorAssembly: Assembly {
    func assemble(container: Container) {
        container.register(BillingCoordinatorProtocol.self) { (r, navigationController: UINavigationController) in
            BillingCoordinator(navigationController: navigationController)
        }
    }
}
