//
//  OlchaAuthCoordinatorProtocol.swift
//  OlchaMarketModule
//
//  Created by Elbek Khasanov on 26/07/23.
//

import UIKit
import OlchaAuth
public protocol OlchaAuthCoordinatorProtocol {
    func pushAuth(isSet: Bool, completion: (() -> Void)?)
}

public class OlchaAuthCoordinator: OlchaAuthCoordinatorProtocol {
    private let authCoordinator: AuthCoordinatorProtocol
    
    public init(navigationController: UINavigationController) {
        authCoordinator = AuthDIContainer.shared.resolve(argument: navigationController)
    }
    
    public func pushAuth(isSet: Bool, completion: (() -> Void)?) {
        if AuthGlobalDefaults.isUser() {
            completion?()
        } else {
            authCoordinator.pushAuth(isSet: isSet) {
                CartViewModel.shared.loadCart()
                CartViewModel.shared.mergeFavorites()
                CompareViewModel.shared.mergeCompare()
                completion?()
            }
        }
    }
}
