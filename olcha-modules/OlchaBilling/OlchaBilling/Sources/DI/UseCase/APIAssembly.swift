//
//  ViewAssembly.swift
//  OlchaAuth
//
//  Created by Elbek Khasanov on 26/05/23.
//

import Foundation
import Swinject
import OlchaUI
import OlchaUtils

final class APIAssembly: Assembly {
    func assemble(container: Container) {
        container.register(BillingAPIProtocol.self) { (r) in
            return BillingAPI()
        }
    }
}
