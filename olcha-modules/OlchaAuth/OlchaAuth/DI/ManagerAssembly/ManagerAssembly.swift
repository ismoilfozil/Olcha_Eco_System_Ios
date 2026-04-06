//
//  ManagerAssembly.swift
//  OlchaAuth
//
//  Created by Elbek Khasanov on 26/05/23.
//

import Alamofire
import Swinject
import OlchaCore
import UIKit
final class ManagerAssembly: Assembly {
    func assemble(container: Container) {
        container.register(AuthCoordinatorProtocol.self) { (r, navigationController: UINavigationController) in
            return AuthCoordinator(navigationController: navigationController)
        }
        
        container.register(RequestInterceptor.self, name: .core) { r in
            return AuthInterceptor()
        }.inObjectScope(.container)
        
        container.register(NetworkManagerProtocol.self) { r in
            let interceptor = r.resolve(RequestInterceptor.self, name: .core)!
            return CoreDIContainer.shared.networkManager(interceptor: interceptor, name: .core)
        }
    }
}
