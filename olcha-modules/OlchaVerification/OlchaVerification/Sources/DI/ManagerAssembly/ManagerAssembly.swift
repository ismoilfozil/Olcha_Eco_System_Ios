//
//  CoordinatorAssembly.swift
//  OlchaVerification
//
//  Created by Elbek Khasanov on 22/05/23.
//

import UIKit
import OlchaAuth
import Swinject
import Alamofire
import OlchaCore

final class ManagerAssembly: Assembly {
    func assemble(container: Container) {
        
        container.register(NetworkManagerProtocol.self) { r in
            
            let interceptor: RequestInterceptor = AuthDIContainer.shared.resolve(name: .core)
            return CoreDIContainer.shared.networkManager(interceptor: interceptor, name: .core)
            
        }
        
    }
}
