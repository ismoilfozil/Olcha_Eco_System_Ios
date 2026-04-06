//
//  OlchaVerificationAssembly.swift
//  OlchaVerification
//
//  Created by Elbek Khasanov on 20/05/23.
//

import Foundation
import OlchaBankCards
import Swinject
final class ViewAssembly: Assembly {
    public func assemble(container: Container) {
        container.register(PassportsVerificationPageProtocol.self) { r in
            let viewModel = r.resolve(VerificationViewModel.self)!
            return PassportsVerificationPage(viewModel: viewModel)
        }
        
        container.register(MyIdPassportInfoPageProtocol.self) { r in
            let viewModel = r.resolve(VerificationViewModel.self)!
            return MyIdPassportInfoPage(viewModel: viewModel)
        }
        
        container.register(BankCardsVerificationPageProtocol.self) { r in
            let verificationViewModel = r.resolve(VerificationViewModel.self)!
            let bankCardViewModel: BankCardViewModel = BankCardsDIContainer.shared.resolve()
            return BankCardsVerificationPage(bankCardViewModel: bankCardViewModel, verificationViewModel: verificationViewModel)
        }
        
        container.register(PhonesVerificationPageProtocol.self) { r in
            let viewModel = r.resolve(VerificationViewModel.self)!
            return PhonesVerificationPage(viewModel: viewModel)
        }
        
        container.register(CartVerificationPageProtocol.self) { r in
            let verificationViewModel = r.resolve(VerificationViewModel.self)!
            let bankCardViewModel: BankCardViewModel = BankCardsDIContainer.shared.resolve()
            return CartVerificationPage(bankCardViewModel: bankCardViewModel, verificationViewModel: verificationViewModel)
        }
        
        container.register(VerifyTimerViewController.self) { _ in
            return VerifyTimerViewController()
        }
        
        container.register(SuccessViewController.self) { _ in
            return SuccessViewController()
        }
        
        container.register(DenyViewController.self) { _ in
            return DenyViewController()
        }
    }
}
