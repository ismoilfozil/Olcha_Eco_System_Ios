//
//  AuthCoordinator.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 28/02/23.
//

import UIKit
import OlchaUI
public protocol AuthCoordinatorProtocol: AnyObject {
    var authNavigationController: BaseNavigation { get set }
    var isSet: Bool { get set }
    var navigationController: UINavigationController { get set }
    var phone: String? { get set }
    var code: String? { get set }
    var lastPage: UIViewController.Type? { get set }
    var dismissedViewController: UIViewController? { get set }
    var completion: (() -> Void)? { get set }
    
    func pushAuth(isSet: Bool, completion: (() -> Void)?)
    func pushAuth(isSet: Bool, canDismiss: Bool, completion: (() -> Void)?)
    func pushLogin()
    func pushResetPasswordPhone()
    
    func pushResetPassword()
    
    func pushConfirmCode(authHelper: ConfirmCodeHelper?)
    
    func pushRegistration()
    func finishAuth()
    func closeAuth(shouldPresent: Bool)
    
    func presentHistoricalDismissedViewController()
    func dismissPresentedViewController()
    func dismissViewController()
}

extension AuthCoordinatorProtocol {
    public func finishAuth() {
        completion?()
        closeAuth(shouldPresent: false)
    }
    
    public func closeAuth(shouldPresent: Bool) {
        navigationController.dismiss(animated: true) { [weak self] in
            guard shouldPresent else { return }
            self?.presentHistoricalDismissedViewController()
        }
        AuthViewModel.shared.storeUserDevice()
    }
    
    public func presentHistoricalDismissedViewController() {
        
        if let vc = self.dismissedViewController {
            navigationController.presentModally(vc)
            self.dismissedViewController = nil
        }
        
    }
    
    public func dismissPresentedViewController() {
        if navigationController.presentedViewController is ModalPageType {
            self.dismissedViewController = navigationController.presentedViewController
            dismissViewController()
        }
    }
    
    public func dismissViewController() {
        navigationController.presentedViewController?.dismiss(animated: true, completion: nil)
    }
}

public class AuthCoordinator: AuthCoordinatorProtocol {
    
    public var authNavigationController: BaseNavigation
    
    public var isSet: Bool = false
    
    public var lastPage: UIViewController.Type?
    
    public var dismissedViewController: UIViewController?
    
    public var completion: (() -> Void)?
    
    public var phone: String?
    
    public var code: String?
    
    public var navigationController: UINavigationController
    
    public init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        authNavigationController = BaseNavigation()
        authNavigationController.modalPresentationStyle = .fullScreen
    }
    
    public func pushAuth(isSet: Bool, completion: (() -> Void)?) {
        pushAuthExecute(isSet: isSet, canDismiss: true, completion: completion)
    }
    
    public func pushAuth(isSet: Bool, canDismiss: Bool, completion: (() -> Void)?) {
        pushAuthExecute(isSet: isSet, canDismiss: canDismiss, completion: completion)
    }
    
    private func pushAuthExecute(isSet: Bool, canDismiss: Bool, completion: (() -> Void)?) {
        self.isSet = isSet
        dismissedViewController = navigationController.presentedViewController
        
        self.completion = completion
        if AuthGlobalDefaults.isUser() {
            completion?()
        } else {
            let vc: WelcomePageProtocol = AuthDIContainer.shared.resolve()
            vc.coordinator = self
            vc.canDismiss = canDismiss
            
            vc.loginObserver = { [weak self] in
                guard let self = self else { return }
                pushLogin()
            }
            
            vc.pushRegistrationObserver = { [weak self] in
                guard let self = self else { return }
                pushRegistration()
            }
            
            vc.pushConfirmCode = { [weak self] authHelper in
                guard let self = self else { return }
                pushConfirmCode(authHelper: authHelper)
            }
            
            if isSet {
                navigationController.set([vc])
            } else {
                authNavigationController.set([vc])
                navigationController.present(authNavigationController, animated: true)
            }
            lastPage = WelcomePage.self
        }
    }
    
    public func pushLogin() {
        let vc: LoginViewControllerProtocol = AuthDIContainer.shared.resolve()
        
        vc.coordinator = self
        
        vc.authCompletion = { [weak self] in
            guard let self = self else { return }
            finishAuth()
        }
        
        vc.resetPasswordObserver = { [weak self] in
            guard let self = self else { return }
            pushResetPasswordPhone()
        }
        
        pushVC(with: isSet ? navigationController : authNavigationController, for: vc)
    }
    
    public func pushResetPasswordPhone() {
        let vc: ResetPasswordPhoneViewControllerProtocol = AuthDIContainer.shared.resolve()
        
        vc.coordinator = self
        
        vc.pushConfirmCode = { [weak self] authHelper in
            guard let self = self else { return }
            pushConfirmCode(authHelper: authHelper)
        }
        
        vc.pushResetPassword = { [weak self] in
            guard let self = self else { return }
            pushResetPassword()
        }
        
        authNavigationController.push(vc)
    }
    
    public func pushResetPassword() {
        let vc: ResetPasswordViewControllerProtocol = AuthDIContainer.shared.resolve()
        
        vc.coordinator = self
        
        vc.authCompletion = { [weak self] in
            guard let self = self else { return }
            finishAuth()
        }
        
        pushVC(with: isSet ? navigationController : authNavigationController, for: vc)
    }
    
    public func pushRegistration() {
        let vc: RegistrationViewControllerProtocol = AuthDIContainer.shared.resolve()
        vc.coordinator = self
        
        vc.authCompletion = { [weak self] in
            guard let self = self else { return }
            finishAuth()
        }
        
        pushVC(with: isSet ? navigationController : authNavigationController, for: vc)
    }
    
    public func pushConfirmCode(authHelper: ConfirmCodeHelper?) {
        let vc: ConfirmCodeViewControllerProtocol = AuthDIContainer.shared.resolve()
        vc.phone = phone 
        vc.authHelper = authHelper
        presentVCModally(with: isSet ? navigationController : authNavigationController, for: vc)
    }
    
    private func pushVC(with navController: UINavigationController, for vc: UIViewController) {
        navController.push(vc)
    }
    
    private func presentVCModally(with navController: UINavigationController, for vc: UIViewController) {
        navController.presentModally(vc)
    }
}
