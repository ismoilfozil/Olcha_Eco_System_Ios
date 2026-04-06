//
//  RepositoryAssembly.swift
//  OlchaBankCards
//
//  Created by Elbek Khasanov on 22/06/23.
//

import Foundation
import OlchaAuth
import OlchaCore
import OlchaUtils
import Alamofire
import Swinject

final class ManagerAssembly: Assembly {
    public func assemble(container: Container) {
        container.register(NetworkManagerProtocol.self) { r in
            
            let interceptor: RequestInterceptor = AuthDIContainer.shared.resolve(name: .core)
            return CoreDIContainer.shared.networkManager(interceptor: interceptor, name: .core)
            
        }
        
        container.register(BankCardAPIProtocol.self) { (r, argument: String?) in
            return BankCardAPI()
        }
    }
}
