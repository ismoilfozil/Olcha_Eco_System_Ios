//
//  RepositoryAssembly.swift
//  OlchaAuth
//
//  Created by Elbek Khasanov on 24/05/23.
//

import Foundation
import OlchaCore
import Swinject
final class RepositoryAssembly: Assembly {
    func assemble(container: Swinject.Container) {
        container.register(LoginRepositoryProtocol.self) { r in
            let api = r.resolve(LoginAPIProtocol.self)!
            let manager = r.resolve(NetworkManagerProtocol.self)!
            return LoginRepository(api: api, manager: manager)
        }
        
        container.register(AuthRepositoryProtocol.self) { r in
            let api = r.resolve(AuthAPIProtocol.self)!
            let manager = r.resolve(NetworkManagerProtocol.self)!
            return AuthRepository(api: api, manager: manager)
        }
        
        container.register(ProfileRepositoryProtocol.self) { r in
            let api = r.resolve(ProfileAPIProtocol.self)!
            let manager = r.resolve(NetworkManagerProtocol.self)!
            return ProfileRepository(api: api, manager: manager)
        }
    }
}
