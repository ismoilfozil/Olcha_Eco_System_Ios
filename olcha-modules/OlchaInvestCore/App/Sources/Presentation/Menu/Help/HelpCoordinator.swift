//
//  HelpCoordinator.swift
//  OlchaInvestCore
//
//  Created by Akhrorkhuja on 05/06/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import UIKit
import OlchaUI

public protocol HelpCoordinatorProtocol: Coordinator {
    func pushWriteUsViewController()
    func pushFaqViewController()
}

public final class HelpCoordinator: HelpCoordinatorProtocol {
    
    public var navigationController: UINavigationController
    
    public init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    public func start() {
        let vc: HelpViewController = InvestDIContainer.shared.resolve()
        vc.coordinator = self
        navigationController.push(vc)
    }
    
    public func pushWriteUsViewController() {
        let vc: WriteUsViewController = InvestDIContainer.shared.resolve()
        navigationController.push(vc)
    }
    
    public func pushFaqViewController() {
        let vc: FaqViewController = InvestDIContainer.shared.resolve()
        vc.coordinator = self
        navigationController.push(vc)
    }
    
}
