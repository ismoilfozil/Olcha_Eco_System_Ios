//
//  ProfileAssembly.swift
//  OlchaInvestCore
//
//  Created by Akhrorkhuja on 30/05/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import Swinject
import OlchaAuth
import OlchaBilling
import OlchaUtils
public final class ProfileAssembly: Assembly {
    
    public func assemble(container: Container) {
        container.register(ProfileViewController.self) { _ in
            let billingViewModel: BillingViewModel = BillingDIContainer.shared.resolve()
            let profileViewModel: ProfileViewModel = AuthDIContainer.shared.resolve(name: .shared)
            return ProfileViewController(
                billingViewModel: billingViewModel,
                profileViewModel: profileViewModel
            )
        }
        
        container.register(PersonalDataViewController.self) { _ in
            let viewModel: ProfileViewModel = AuthDIContainer.shared.resolve()
            return PersonalDataViewController(viewModel: viewModel)
        }
        
        container.register(SettingsViewController.self) { _ in
            return SettingsViewController()
        }
        
        container.register(SafetyViewController.self) { _ in
            let viewModel: ProfileViewModel = AuthDIContainer.shared.resolve()
            return SafetyViewController(viewModel: viewModel)
        }
        
    }
    
}
