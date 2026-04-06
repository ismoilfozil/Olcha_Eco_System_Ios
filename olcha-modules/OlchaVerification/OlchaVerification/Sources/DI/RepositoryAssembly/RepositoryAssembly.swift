//
//  CoordinatorAssembly.swift
//  OlchaVerification
//
//  Created by Elbek Khasanov on 22/05/23.
//

import UIKit
import Swinject
import OlchaCore
final class RepositoryAssembly: Assembly {
    func assemble(container: Container) {
        container.register(VerificationRepositoryProtocol.self) { r in
            let manager = r.resolve(NetworkManagerProtocol.self)!
            let api = r.resolve(VerificationAPIProtocol.self)!
            return VerificationRepository(manager: manager,
                                          api: api)
        }
        
        container.register(MyIdRepositoryProtocol.self) { r in
            let manager = r.resolve(NetworkManagerProtocol.self)!
            let api = r.resolve(MyIdAPIProtocol.self)!
            return MyIdRepository(manager: manager, api: api)
        }
    }
}
