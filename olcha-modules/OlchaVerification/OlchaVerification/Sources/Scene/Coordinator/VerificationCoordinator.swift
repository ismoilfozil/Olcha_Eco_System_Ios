//
//  VerificationCoordinator.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 15/09/22.
//

import UIKit
import Combine
import OlchaUI
import OlchaBankCards

public class VerificationCoordinator: Coordinator, VerificationCoordinatorProtocol {
  
    
    public var bag: Set<AnyCancellable> = .init()
    
    public var picker: OlchaUI.MediaPicker?
    
    public var dismissedViewController: UIViewController?
    
    public var presentLastPage: PassthroughSubject<Bool, Never> = .init()
    
    public var navigationController: UINavigationController
    
    public var completion: (() -> Void)? = nil
    
    public init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        setupObserver()
    }
    
    public func pushPassportVerification(withStatus: Bool) {
        let vc: PassportsVerificationPageProtocol = OlchaVerificationDIContainer.shared.resolve()
        vc.withStatus = withStatus
        vc.coordinator = self
        vc.completion = { [weak self] in
            guard let self = self else { return }
            pushPhonesVerification(withStatus: true)
        }
        navigationController.push(vc)
    }
    
    public func pushMyIdVerification() {
        let vc: MyIdPassportInfoPageProtocol = OlchaVerificationDIContainer.shared.resolve()
        vc.coordinator = self
        vc.completion = { [weak self] in
            guard let self = self else { return }
            pushPhonesVerification(withStatus: true)
        }
        navigationController.push(vc)
    }
  
    
    public func pushPhonesVerification(withStatus: Bool) {
        let vc: PhonesVerificationPageProtocol = OlchaVerificationDIContainer.shared.resolve()
        vc.withStatus = withStatus
        vc.coordinator = self
        vc.completion = { [weak self] in
            guard let self = self else { return }
            pushBankCardsPage(withStatus: true)
        }
        navigationController.push(vc)
    }
    
    public func pushBankCardsPage(withStatus: Bool) {
        let vc: BankCardsVerificationPageProtocol = OlchaVerificationDIContainer.shared.resolve()
        vc.withStatus = withStatus
        vc.coordinator = self
        vc.completion = { [weak self] in
            guard let self else { return }
            navigationController.popToRootViewController(animated: true)
        }
        navigationController.push(vc)
    }
    
}
