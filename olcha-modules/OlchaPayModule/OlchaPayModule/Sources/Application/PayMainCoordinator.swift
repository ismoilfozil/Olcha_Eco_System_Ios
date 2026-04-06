//
//  MainCoordinator.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 09/02/23.
//

import UIKit
import OlchaAuth
import OlchaUI
public class PayMainCoordinator: NSObject, Coordinator {
    
    public var navigationController: UINavigationController
    
    public lazy var payHomeCoordinator: PayHomeCoordinatorProtocol = PayHomeCoordinator(navigationController: navigationController)
    public lazy var mainCardsCoordinator: MainCardsCoordinatorProtocol = MainCardsCoordinator(navigationController: navigationController)
    public lazy var paymentsCoordinator: PaymentsCoordinatorProtocol = PaymentsCoordinator(navigationController: navigationController)
    public lazy var profileCoordinator: ProfileCoordinatorProtocol = ProfileCoordinator(navigationController: navigationController)
    public lazy var authCoordinator: AuthCoordinatorProtocol = AuthCoordinator(navigationController: navigationController)
    public lazy var monitoringCoordinator: MonitoringCoordinatorProtocol = MonitoringCoordinator(navigationController: navigationController)
    
    public init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    public func start() { }
    
}
