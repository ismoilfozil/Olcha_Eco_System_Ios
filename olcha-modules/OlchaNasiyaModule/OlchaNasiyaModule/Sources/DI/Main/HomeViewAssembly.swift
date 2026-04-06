//
//  MainViewAssembly.swift
//  OlchaNasiyaModule
//
//  Created by Elbek Khasanov on 10/05/23.
//

import Foundation
import Swinject
import OlchaAuth
import OlchaCommon
import OlchaBilling
import OlchaUtils
import OlchaVerification

final class HomeViewAssembly: Assembly {
    func assemble(container: Container) {
        container.register(NasiyaHomeViewController.self) { r in
            let installmentViewModel = r.resolve(InstallmentViewModel.self)!
            let homeViewModel = r.resolve(NasiyaHomeViewModel.self)!
            let profileViewModel: ProfileViewModel = AuthDIContainer.shared.resolve(name: .shared)
            let billingViewModel: BillingViewModel = BillingDIContainer.shared.resolve()
            let commonViewModel: CommonViewModel = CommonDIContainer.shared.resolve(argument: Organization.nasiya)
            let verificationViewModel: VerificationViewModel = OlchaVerificationDIContainer.shared.resolve()
            
            return NasiyaHomeViewController(
                installmentViewModel: installmentViewModel,
                billingViewModel: billingViewModel,
                profileViewModel: profileViewModel,
                homeViewModel: homeViewModel,
                commonViewModel: commonViewModel,
                verificationViewModel: verificationViewModel
            )
        }
        
        container.register(NasiyaFAQViewController.self) { r in
            let viewModel: CommonViewModel = CommonDIContainer.shared.resolve(argument: Organization.nasiya)
            return NasiyaFAQViewController(viewModel: viewModel)
        }
    }
}
