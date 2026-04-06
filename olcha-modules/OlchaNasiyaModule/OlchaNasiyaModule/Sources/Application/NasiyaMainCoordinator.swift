//
//  NasiyaMainCoordinator.swift
//  OlchaNasiyaModule
//
//  Created by Elbek Khasanov on 10/05/23.
//

import UIKit
import OlchaUI
import OlchaAuth
import OlchaBilling
public class NasiyaMainCoordinator: NSObject, Coordinator {
    public var navigationController: UINavigationController
    
    public lazy var authCoordinator: AuthCoordinatorProtocol = AuthDIContainer.shared.resolve(argument: navigationController)
    public lazy var nasiyaHomeCoordinator: NasiyaHomeCoordinatorProtocol = NasiyaHomeCoordinator(navigationController: navigationController)
    public lazy var installmentsCoordinator: MyInstallmentsCoordinatorProtocol = MyInstallmentsCoordinator(navigationController: navigationController)
    public lazy var partnerCoordinator: PartnerCoordinatorProtocol = PartnerCoordinator(navigationController: navigationController)
    public lazy var profileCoordinator: ProfileCoordinatorProtocol = ProfileCoordinator(navigationController: navigationController)
    public lazy var menuCoordinator: NasiyaMenuCoordinatorProtocol = NasiyaMenuCoordinator(navigationController: navigationController)
    public lazy var billingCoordinator: BillingCoordinatorProtocol = BillingDIContainer.shared.resolve(argument: navigationController)
    
    public init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    public func start() {}
    
    
}
