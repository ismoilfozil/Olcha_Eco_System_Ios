//
//  ProfileAssembly.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 24/02/23.
//

import Foundation
import Swinject
import OlchaAuth

final class ProfileViewAssembly: Assembly {
    func assemble(container: Container) {
        
        container.register(ProfileViewController.self) { r in
            let viewModel: ProfileViewModel = AuthDIContainer.shared.resolve()
            return ProfileViewController(viewModel: viewModel)
        }
        
        container.register(PrivacyViewController.self) { r in
            return PrivacyViewController()
        }
        
        container.register(SettingsViewController.self) { r in
            return SettingsViewController()
        }
        
        container.register(ProfileDataViewController.self) { r in
            let viewModel: ProfileViewModel = AuthDIContainer.shared.resolve()
            return ProfileDataViewController(viewModel: viewModel)
        }
        
        container.register(EditNameModalPage.self) { r in
            return EditNameModalPage()
        }
        
        container.register(EditMailModalPage.self) { r in
            return EditMailModalPage()
        }
        
        container.register(NewsListViewController.self) { r in
            let viewModel = r.resolve(NewsViewModel.self)!
            return NewsListViewController(newsViewModel: viewModel)
        }
    }
}
