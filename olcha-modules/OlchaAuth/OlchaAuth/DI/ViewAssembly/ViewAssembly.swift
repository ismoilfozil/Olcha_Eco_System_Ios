//
//  ViewAssembly.swift
//  OlchaAuth
//
//  Created by Elbek Khasanov on 26/05/23.
//

import Foundation
import Swinject
import OlchaUI
final class ViewAssembly: Assembly {
    func assemble(container: Container) {
        
        container.register(EditPasswordModalPage.self) { r in
            let viewModel = r.resolve(AuthViewModel.self)!
            return EditPasswordModalPage(viewModel: viewModel)
        }
        
        container.register(WelcomePageProtocol.self) { r in
            let viewModel = r.resolve(AuthViewModel.self)!
            return WelcomePage(viewModel: viewModel)
        }
        
        container.register(LoginViewControllerProtocol.self) { r in
            let viewModel = r.resolve(AuthViewModel.self)!
            return LoginViewController(viewModel: viewModel)
        }
        
        container.register(ResetPasswordPhoneViewControllerProtocol.self) { r in
            let viewModel = r.resolve(AuthViewModel.self)!
            return ResetPasswordPhoneViewController(viewModel: viewModel)
        }
        
        container.register(ResetPasswordViewControllerProtocol.self) { r in
            let viewModel = r.resolve(AuthViewModel.self)!
            return ResetPasswordViewController(viewModel: viewModel)
        }
        
        container.register(RegistrationViewControllerProtocol.self) { r in
            let viewModel = r.resolve(AuthViewModel.self)!
            return RegistrationViewController(viewModel: viewModel)
        }
        
        container.register(ConfirmCodeViewControllerProtocol.self) { r in
            return ConfirmCodeViewController()
        }
        
    }
}
