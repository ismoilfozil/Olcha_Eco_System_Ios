//
//  ManagerAssembly.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 15/01/24.
//

import Foundation
import Swinject
import OlchaCore
import OlchaAuth
import OlchaUtils
import Combine
import Alamofire

class ManagerAssembly: Assembly {
    func assemble(container: Swinject.Container) {
        container.register(NetworkManagerProtocol.self) { r in
            
            let interceptor: RequestInterceptor = AuthDIContainer.shared.resolve(name: .core)
            return CoreDIContainer.shared.networkManager(interceptor: interceptor, name: .core)
            
        }
    }
}
