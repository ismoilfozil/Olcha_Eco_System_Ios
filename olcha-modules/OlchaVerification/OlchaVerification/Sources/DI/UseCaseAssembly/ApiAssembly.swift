//
//  CoordinatorAssembly.swift
//  OlchaVerification
//
//  Created by Elbek Khasanov on 22/05/23.
//

import UIKit
import Swinject
final class ApiAssembly: Assembly {
    func assemble(container: Container) {
        container.register(VerificationAPIProtocol.self) { r in
            return VerificationAPI()
        }
        
        container.register(MyIdAPIProtocol.self){ r in
            return MyIdAPI()
        }
    }
}
