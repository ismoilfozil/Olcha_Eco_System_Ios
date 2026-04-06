//
//  CommonAssembly.swift
//  OlchaInvestCore
//
//  Created by Akhrorkhuja on 27/05/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import Swinject
import OlchaCore
import OlchaUI
import OlchaAuth

public final class AppAssembly: Assembly {
 
    public func assemble(container: Container) {
        container.register(MenuViewController.self) { (r, navigation: BaseNavigation) in
            
            let profileViewModel: ProfileViewModel = AuthDIContainer.shared.resolve(name: .shared)
            let menuVC = MenuViewController(profileViewModel: profileViewModel)
            
            return menuVC
        }
        
    }
    
}
