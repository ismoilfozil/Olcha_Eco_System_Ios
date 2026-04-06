//
//  ManagerAssembly.swift
//  OlchaBilling
//
//  Created by Elbek Khasanov on 21/06/23.
//
import Foundation
import Swinject
import OlchaUI
import OlchaCore
import Alamofire
import OlchaAuth

final class ManagerAssembly: Assembly {
    func assemble(container: Container) {
        container.register(NetworkManagerProtocol.self) { r in
            
            let interceptor: RequestInterceptor = AuthDIContainer.shared.resolve(name: .core)
            return CoreDIContainer.shared.networkManager(interceptor: interceptor, name: .core)
            
        }
    }
}
