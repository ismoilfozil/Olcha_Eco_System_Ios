//
//  OnboardingAssembly.swift
//  OlchaNasiyaModule
//
//  Created by Elbek Khasanov on 10/05/23.
//

import UIKit
import Swinject
import OlchaCommon

final class OnboardingViewAssembly: Assembly {
    func assemble(container: Container) {

        container.register(CommonCoordinatorProtocol.self) { (r, navigationController: UINavigationController) in
            
            OnboardingConfigurator.configure(bundleType: .olchaNasiyaModule,
                                             application: .nasiya,
                                             pages: 4,
                                             group_bundle_name: NasiyaTexts.groupBundle)
            
            return CommonCoordinator(navigationController: navigationController)
        }
        
    }
}
