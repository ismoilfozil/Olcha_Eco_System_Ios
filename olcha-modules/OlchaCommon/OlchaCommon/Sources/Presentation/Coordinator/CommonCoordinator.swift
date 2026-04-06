//
//  OnboardingCoordinator.swift
//  OlchaCommon
//
//  Created by Elbek Khasanov on 10/10/23.
//

import UIKit
import OlchaUI
import OlchaAuth
import OlchaPincode
public protocol CommonCoordinatorProtocol: Coordinator {
    func pushOnboarding(completion: (() -> Void)?)
    func presentLanguageOnboarding()
    func pushSafety(logout: (() -> Void)?)
    func pushEditPincode()
    func presentEditPassword()
    func pushAddPincode()
}

public class CommonCoordinator: CommonCoordinatorProtocol {
    private let pincodeCoordinator: PincodeCoordinatorProtocol
    private var logout: (() -> Void)?
    public var navigationController: UINavigationController
    
    public init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.pincodeCoordinator = PincodeCoordinator(navigationController: navigationController, state: .edit)
    }
    
    public func start() {}
    
    public func pushOnboarding(completion: (() -> Void)?) {
        let vc: OnboardingViewController = CommonDIContainer.shared.resolve()
        vc.coordinator = self
        vc.completion = completion
        navigationController.push(vc)
    }
    
    public func presentLanguageOnboarding() {
        let vc: OnboardingLanguageModalViewController = CommonDIContainer.shared.resolve()
        navigationController.presentModally(vc)
    }
    
    public func pushAddPincode() {
        pincodeCoordinator.startAddPincodeFlow()
        pincodeCoordinator.completion = { [weak self] in
            guard let self else { return }
            navigationController.popViewController(to: SafetyViewController.self)
        }
    }
    
    public func pushEditPincode() {
        pincodeCoordinator.startEditPincodeFlow()
        pincodeCoordinator.completion = { [weak self] in
            guard let self = self else { return }
            navigationController.popViewController(to: SafetyViewController.self)
        }
        
        pincodeCoordinator.logout = logout
    }
    
    public func presentEditPassword() {
        let vc: EditPasswordModalPage = AuthDIContainer.shared.resolve()
        navigationController.presentModally(vc)
    }
    
    public func pushSafety(logout: (() -> Void)?) {
        self.logout = logout
        let vc: SafetyViewController = CommonDIContainer.shared.resolve()
        vc.coordinator = self
        navigationController.push(vc)
    }
}
