//
//  VerificationAssembly.swift
//  OlchaNasiyaModule
//
//  Created by Elbek Khasanov on 11/07/23.
//
import OlchaVerification
import UIKit

final class VerificationAssembly {
    static let shared = VerificationAssembly()
    
    func setupAssembly() {
        OlchaVerificationDIContainer.shared.container.register(
            VerificationCoordinatorProtocol.self,
            name: VerificationCoordinator.classIdentifier) { (r, navigationController: UINavigationController) in
            return VerificationCoordinator(navigationController: navigationController)
        }
        
        OlchaVerificationDIContainer.shared.container.register(
            VerificationCoordinatorProtocol.self,
            name: NasiyaVerificationCoordinator.classIdentifier) { (r, navigationController: UINavigationController) in
            return NasiyaVerificationCoordinator(navigationController: navigationController)
        }
        
        OlchaVerificationDIContainer.shared.container.register(VerificationAPIProtocol.self) { (r) in
            return NasiyaVerificationAPI()
        }
    }
}
