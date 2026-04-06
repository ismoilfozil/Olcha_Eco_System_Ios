//
//  ViewAssembly.swift
//  OlchaAuth
//
//  Created by Elbek Khasanov on 26/05/23.
//

import Foundation
import Swinject
import OlchaUI
import OlchaBankCards
import OlchaUtils
import OlchaVerification

final class ViewAssembly: Assembly {
    func assemble(container: Container) {
        container.register(BillingPaymentViewController.self) { (r) in
            
            let viewModel = r.resolve(BillingViewModel.self)!
            return BillingPaymentViewController(viewModel: viewModel)
        }

        container.register(AddBillingCardModalPage.self) { r in
            let viewModel: BankCardViewModel = BankCardsDIContainer.shared.resolve(argument: (String.billing as? String))
            return AddBillingCardModalPage(viewModel: viewModel)
        }
        
        container.register(BillingSuccessViewController.self) { r in
            return BillingSuccessViewController()
        }
        
        container.register(BankCardsVerificationPageProtocol.self) { r in
            let viewModel = r.resolve(BillingViewModel.self)!
            let verificationViewModel: VerificationViewModel = OlchaVerificationDIContainer.shared.resolve()
            let bankCardViewModel: BankCardViewModel = BankCardsDIContainer.shared.resolve(argument: (String.billing as? String))
            return BillingCardsVerificationPage(viewModel: viewModel,
                                                bankCardViewModel: bankCardViewModel,
                                                verificationViewModel: verificationViewModel)
        }
    }
}
