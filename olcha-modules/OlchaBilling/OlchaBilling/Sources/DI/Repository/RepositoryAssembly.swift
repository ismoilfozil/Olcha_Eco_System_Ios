//
//  ViewAssembly.swift
//  OlchaAuth
//
//  Created by Elbek Khasanov on 26/05/23.
//

import Foundation
import Swinject
import OlchaUI
import OlchaCore
import OlchaUtils

final class RepositoryAssembly: Assembly {
    func assemble(container: Container) {
        container.register(BillingRepositoryProtocol.self) { (r) in
            let manager = r.resolve(NetworkManagerProtocol.self)!
            let api = r.resolve(BillingAPIProtocol.self)!
            return BillingRepository(manager: manager, api: api)
        }
    }
}
