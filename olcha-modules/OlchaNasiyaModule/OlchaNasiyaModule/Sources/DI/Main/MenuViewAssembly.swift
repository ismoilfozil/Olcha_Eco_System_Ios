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
final class MenuViewAssembly: Assembly {
    func assemble(container: Container) {
        
        container.register(SideMenuViewController.self) { r in
            let viewModel: ProfileViewModel = AuthDIContainer.shared.resolve(name: .shared)
            return SideMenuViewController(viewModel: viewModel)
        }
        
        container.register(SideMenuNavigationController.self) { (r, vc: SideMenuViewController) in
            var settings = SideMenuSettings()
            settings.menuWidth = UIScreen.width
            
            let navController = SideMenuNavigationController(rootViewController: vc,
                                                             settings: settings)
            navController.leftSide = true
            navController.dismissOnPush = true
            navController.presentationStyle = .menuSlideIn
            
            return navController
        }
        
    }
}
