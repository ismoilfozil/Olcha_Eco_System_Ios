//
//  MenuCoordinator.swift
//  OlchaInvestCore
//
//  Created by Akhrorkhuja on 30/05/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import UIKit
import OlchaUI
import OlchaAuth
import SideMenu

public protocol MenuCoordinatorProtocol: Coordinator, HelpCoordinatorProtocol {
    func pushSuggestionsViewController()
    func pushSuggestionDetailViewController(id: Int)
    func pushHelpViewController()
    func logout()
}

public class MenuCoordinator: MenuCoordinatorProtocol {
    public var navigationController: UINavigationController
    
    public init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    public func start() {
        let menuVC: MenuViewController = InvestDIContainer.shared.resolve()
        menuVC.coordinator = self
        let menuNavigationController: SideMenuNavigationController = InvestDIContainer.shared.resolve(argument: menuVC)
        navigationController.present(menuNavigationController, animated: true)
    }
    
    public func pushSuggestionsViewController() {
        navigationController.dismiss()
        let suggestionCoordinator = SuggestionCoordinator(navigationController: navigationController)
        suggestionCoordinator.start()
    }
    
    public func pushSuggestionDetailViewController(id: Int) {
        navigationController.dismiss()
        let suggestionCoordinator = SuggestionCoordinator(navigationController: navigationController)
        suggestionCoordinator.pushSuggestionDetailViewController(postId: id)
    }
    
    public func pushFaqViewController() {
        let vc: FaqViewController = InvestDIContainer.shared.resolve()
        vc.coordinator = self
        navigationController.dismissablePush(vc)
    }
    
    public func pushWriteUsViewController() {
        let vc: WriteUsViewController = InvestDIContainer.shared.resolve()
        navigationController.dismissablePush(vc)
    }
    
    public func pushHelpViewController() {
        navigationController.dismiss()
        let coordinator = HelpCoordinator(navigationController: navigationController)
        coordinator.start()
    }
    
    public func logout() {
        navigationController.showLogout {
            InvestAppConfigurator.shared.appCoordinator?.logout()            
        }
    }
    
}
