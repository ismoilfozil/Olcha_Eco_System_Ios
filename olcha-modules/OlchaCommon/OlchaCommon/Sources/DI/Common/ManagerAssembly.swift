//
//  ManagerAssembly.swift
//  OlchaNasiyaModule
//
//  Created by Elbek Khasanov on 24/05/23.
//

import UIKit
import Swinject
import Alamofire
import OlchaCore
import OlchaAuth
final class ManagerAssembly: Assembly {
    func assemble(container: Container) {
        container.register(NetworkManagerProtocol.self) { r in
            let interceptor: RequestInterceptor = AuthDIContainer.shared.resolve(name: .core)
            return CoreDIContainer.shared.networkManager(interceptor: interceptor, name: .core)
        }

        container.register(CommonCoordinatorProtocol.self) { (r, navigationController: UINavigationController) in
            MainActor.assumeIsolated { CommonCoordinator(navigationController: navigationController) }
        }
    }
}
