//
//  RepositoryAssembly.swift
//  OlchaBankCards
//
//  Created by Elbek Khasanov on 22/06/23.
//


import Foundation
import Swinject
import OlchaCore
final class RepositoryAssembly: Assembly {
    public func assemble(container: Container) {
        container.register(BalanceRepositoryProtocol.self) { (r, name: String?) in
            let manager = r.resolve(NetworkManagerProtocol.self)!
            let api = r.resolve(BalanceAPIProtocol.self, argument: name)!
            return BalanceRepository(manager: manager, api: api)
        }
    }
}
