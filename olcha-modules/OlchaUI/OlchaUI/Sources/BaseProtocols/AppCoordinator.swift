//
//  AppCoordinator.swift
//  OlchaUI
//
//  Created by Elbek Khasanov on 10/05/23.
//

import Foundation
import UIKit
import OlchaUtils
///
/// - ``AppStateFlow``: used to control `Application` flow.
///
public enum AppStateFlow {
    case onboarding
    case initialPincode
    case pincode
    case auth
    case home
    case logout
}
///
///
/// - ``AppCoordinatorProtocol`` you need implement  in order to create application flow
///
///
public protocol AppCoordinatorProtocol: AnyObject {
    var navigationController: UINavigationController { get }
    func presentInitialPincode(completion: (() -> Void)?)
    func presentPincode(completion: (() -> Void)?, logout: (() -> Void)?)
    func presentTabController(completion: (() -> Void)?)
    func presentAuth(completion: (() -> Void)?)
    func presentOnboarding(completion: (() -> Void)?)
    func startSplash(completion: (() -> Void)?)
    func start(appStarted: (() -> Void)?)
    func startApp(appStarted: (() -> Void)?)
    func logout()
    func getPincodeState() -> AppStateFlow
    
    func clickActionRouter(action: ClickAction)
    func appFlow(state: AppStateFlow, appStarted: (() -> Void)?, isParent: Bool)
    
}

extension AppCoordinatorProtocol {
    
    public func startApp(appStarted: (() -> Void)? = nil) {
        self.startApp(appStarted: appStarted)
    }
    
    public func presentOnboarding(completion: (() -> Void)?) {
        completion?()
    }
    
    public func presentInitialPincode(completion: (() -> Void)?) {
        completion?()
    }
    
    public func presentPincode(completion: (() -> Void)?) {
        completion?()
    }
    
    public func clickActionRouter(action: ClickAction) {}
///
/// - ``appFlow(state: AppStateFlow, appStarted: (() -> Void)?, isParent: Bool)`` default implementation of appFlow
/// - `state: AppStateFlow`is state of app
/// - `appStarted` is completion handler of presenting tab controller
/// - `isParent` each application can be Parent
///
    public func appFlow(state: AppStateFlow, appStarted: (() -> Void)?, isParent: Bool) {
        switch state {
        case .onboarding:
            presentOnboarding { [weak self] in
                guard let self = self else { return }
                appFlow(state: .auth, appStarted: appStarted, isParent: isParent)
            }
        case .initialPincode:
            presentInitialPincode { [weak self] in
                guard let self = self else { return }
                appFlow(state: .home, appStarted: appStarted, isParent: isParent)
            }
        case .pincode:
            presentPincode { [weak self] in
                guard let self = self else { return }
                appFlow(state: .home, appStarted: appStarted, isParent: isParent)
            } logout: { [weak self] in
                guard let self = self else { return }
                appFlow(state: .logout, appStarted: appStarted, isParent: isParent)
            }
        case .auth:
            presentAuth { [weak self] in
                guard let self = self else { return }
                appFlow(state: getPincodeState(), appStarted: appStarted, isParent: isParent)
            }
        case .home:
            if isParent {
                startSplash { [weak self] in
                    guard let self = self else { return }
                    presentTabController(completion: appStarted)
                }
            } else {
                presentTabController(completion: appStarted)
            }
        case .logout:
            logout()
        }
    }
}
