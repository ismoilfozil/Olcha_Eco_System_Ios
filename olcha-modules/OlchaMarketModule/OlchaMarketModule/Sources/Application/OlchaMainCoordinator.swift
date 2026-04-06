//
//  Coordinator.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 29/06/22.
//

import UIKit
import OlchaAuth
import OlchaBalance
import OlchaUI
import OlchaVerification
public class OlchaMainCoordinator: NSObject, Coordinator {
    
    public var navigationController: UINavigationController
    
    public init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    public func start() {}
    
    public lazy var authCoordinator: OlchaAuthCoordinatorProtocol = OlchaAuthCoordinator(navigationController: navigationController)
    public lazy var searchCoordinator: SearchCoordinatorProtocol = SearchCoordinator(navigationController: navigationController)
    public lazy var profileCoordinator: ProfileCoordinatorProtocol = ProfileCoordinator(navigationController: navigationController)
    public lazy var balanceCoordinator: BalanceCoordinatorProtocol = BalanceCoordinator(navigationController: navigationController)
    public lazy var verificationCoordinator: VerificationCoordinatorProtocol = OlchaVerificationDIContainer.shared.resolve(argument: navigationController)
    public lazy var cartCoordinator: CartCoordinatorProtocol = CartCoordinator(navigationController: navigationController)
    public lazy var brandsCoordinator: BrandsCoordinatorProtocol = BrandsCoordinator(navigationController: navigationController)
    public lazy var catalogCoordinator: CatalogCoordinatorProtocol = CatalogCoordinator(navigationController: navigationController)
    public lazy var featureCoordinator: FeatureCoordinatorProtocol = FeatureCoordinator(navigationController: navigationController)
    public lazy var productCoordinator: ProductCoordinatorProtocol = ProductCoordinator(navigationController: navigationController)

    public lazy var reviewCoordinator: ReviewCoordinatorProtocol = ReviewCoordinator(navigationController: navigationController)

    public lazy var homeCoordinator: HomeCoordinatorProtocol = HomeCoordinator(navigationController: navigationController)

    public lazy var sliderCoordinator: SliderCoordinatorProtocol = SliderCoordinator(navigationController: navigationController)
    
}
