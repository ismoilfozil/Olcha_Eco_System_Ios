//
//  MainViewAssembly.swift
//  OlchaNasiyaModule
//
//  Created by Elbek Khasanov on 10/05/23.
//

import UIKit
import Swinject
import OlchaAuth
import SideMenu

public final class MenuViewAssembly: Assembly {
    public func assemble(container: Container) {
        
        container.register(MenuViewController.self) { _ in
            let viewModel: ProfileViewModel = AuthDIContainer.shared.resolve(name: .shared)
            return MenuViewController(profileViewModel: viewModel)
        }
        
        container.register(SideMenuNavigationController.self) { (_, vc: MenuViewController) in
            var settings = SideMenuSettings()
            settings.menuWidth = UIScreen.width
            settings.presentationStyle.backgroundColor = .black.withAlphaComponent(0.5)
            
            let navController = SideMenuNavigationController(rootViewController: vc,
                                                             settings: settings)
            navController.leftSide = true
            navController.dismissOnPush = true
            navController.presentationStyle = .menuSlideIn
            
            return navController
        }
        
    }
}
