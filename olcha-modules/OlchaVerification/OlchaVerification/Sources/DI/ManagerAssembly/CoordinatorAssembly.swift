//
//  CoordinatorAssembly.swift
//  OlchaVerification
//
//  Created by Elbek Khasanov on 22/05/23.
//

import UIKit
import Swinject
final class CoordinatorAssembly: Assembly {
    func assemble(container: Container) {
        container.register(VerificationCoordinatorProtocol.self) { (r, navigationController: UINavigationController) in
            return VerificationCoordinator(navigationController: navigationController)
        }
    }
}
