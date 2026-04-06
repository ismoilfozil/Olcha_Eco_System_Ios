//
//  EcoSearchCoordinator.swift
//  OlchaEcoSystemCore
//
//  Created by Elbek Khasanov on 27/10/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import UIKit
import OlchaUI
import OlchaUtils
import OlchaCommon
import OlchaNasiyaModule
import OlchaInvestCore
import OlchaMarketModule
import OlchaPayModule

public protocol EcoSearchCoordinatorProtocol: OlchaUI.Coordinator {
    func pushSearchViewController()
    func clickActionRouter(action: ClickAction)
}

public class EcoSearchCoordinator: EcoMainCoordinator, EcoSearchCoordinatorProtocol {
    
    public override func start() {
        let vc: EcoSearchViewController = EcoDIContainer.shared.resolve()
        vc.coordinator = self
        vc.backButtonHidden = true
        navigationController.set([vc], animated: false)
    }
    
    public func pushSearchViewController() {
        let vc: EcoSearchViewController = EcoDIContainer.shared.resolve()
        vc.coordinator = self
        vc.backButtonHidden = false
        navigationController.push(vc)
    }
    
    public func clickActionRouter(action: ClickAction) {
        clickActionCoordinator.clickActionRouter(action: action)
    }
    
}

