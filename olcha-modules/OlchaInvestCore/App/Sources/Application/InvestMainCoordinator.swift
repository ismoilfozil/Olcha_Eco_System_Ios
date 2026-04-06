//
//  InvestMainCoordinator.swift
//  OlchaInvestCore
//
//  Created by Akhrorkhuja on 18/05/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import UIKit
import OlchaUI
import OlchaBalance
public protocol InvestMainCoordinatorProtocol: Coordinator {
    var investHomeCoordinator: InvestHomeCoordinatorProtocol { get set }
    var menuCoordinator: MenuCoordinatorProtocol { get }
}

public class InvestMainCoordinator: NSObject, InvestMainCoordinatorProtocol {
    
    public var navigationController: UINavigationController
    public lazy var investHomeCoordinator: InvestHomeCoordinatorProtocol = InvestHomeCoordinator(navigationController: navigationController)
    public lazy var balanceCoordinator: BalanceCoordinatorProtocol = BalanceCoordinator(navigationController: navigationController)
    public lazy var menuCoordinator: MenuCoordinatorProtocol = MenuCoordinator(navigationController: navigationController)
    
    public init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    public func start() {}
    
}
