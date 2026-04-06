//
//  RepositoryAssembly.swift
//  OlchaNasiyaModule
//
//  Created by Elbek Khasanov on 10/05/23.
//

import Foundation
import OlchaCore
import Swinject
final class RepositoryAssembly: Assembly {
    func assemble(container: Container) {
        container.register(InstallmentRepositoryProtocol.self) { r in
//            return InstallmentMockRepository()
            let manager = r.resolve(NetworkManagerProtocol.self)!
            return InstallmentRepository(manager: manager)
        }
        
        container.register(NasiyaHomeRepositoryProtocol.self) { r in
            let manager = r.resolve(NetworkManagerProtocol.self)!
            return NasiyaHomeRepository(manager: manager)
        }
        
        container.register(PartnerRepositoryProtocol.self) { r in
//            return PartnerMockRepository()
            let manager = r.resolve(NetworkManagerProtocol.self)!
            return PartnerRepository(manager: manager)
        }
        
        container.register(ProfileRepositoryProtocol.self) { r in
            let manager = r.resolve(NetworkManagerProtocol.self)!
            return ProfileRepository(manager: manager)
        }
    }
}
