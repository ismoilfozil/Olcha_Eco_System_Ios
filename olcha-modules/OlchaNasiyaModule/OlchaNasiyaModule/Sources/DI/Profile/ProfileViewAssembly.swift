//
//  ProfileViewAssembly.swift
//  OlchaNasiyaModule
//
//  Created by Elbek Khasanov on 22/05/23.
//
import Foundation
import OlchaAuth
import Swinject
import OlchaVerification

final class ProfileViewAssembly: Assembly {
    func assemble(container: Container) {
        container.register(NasiyaProfileViewController.self) { r in
            let viewModel: ProfileViewModel = AuthDIContainer.shared.resolve(name: .shared)
            let verificationViewModel: VerificationViewModel = OlchaVerificationDIContainer.shared.resolve()
            return NasiyaProfileViewController(profileViewModel: viewModel, verificationViewModel: verificationViewModel)
        }
        
        container.register(ProfileDataViewController.self) { r in
            let viewModel: ProfileViewModel = AuthDIContainer.shared.resolve(name: .shared)
            return ProfileDataViewController(viewModel: viewModel)
        }
        
        container.register(SafetyViewController.self) { r in
            return SafetyViewController()
        }
        
        container.register(SettingsViewController.self) { r in
            return SettingsViewController()
        }
    }
}
