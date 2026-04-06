//
//  RepositoryAssembly.swift
//  OlchaNasiyaModule
//
//  Created by Elbek Khasanov on 10/05/23.
//

import Foundation
import OlchaCore
import Swinject
import OlchaUtils

final class RepositoryAssembly: Assembly {
    func assemble(container: Container) {
        
        container.register(CommonRepositoryProtocol.self) { (r, organization: Organization) in
            let manager = r.resolve(NetworkManagerProtocol.self)!
            let api = r.resolve(CommonAPI.self, argument: organization)!
            return CommonRepository(api: api, manager: manager)
        }
        
        
        container.register(LoyaltyRepositoryProtocol.self) { (r) in
            let manager = r.resolve(NetworkManagerProtocol.self)!
            let api = r.resolve(LoyaltyAPIProtocol.self)!
            return LoyaltyRepository(api: api, manager: manager)
        }
        
        
    }
}
