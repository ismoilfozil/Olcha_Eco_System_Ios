//
//  SuggestionCoordinator.swift
//  OlchaInvestCore
//
//  Created by Akhrorkhuja on 27/06/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import UIKit
import OlchaUI

public protocol SuggestionCoordinatorProtocol: Coordinator {
    func pushSuggestionDetailViewController(postId: Int)
}

final public class SuggestionCoordinator: SuggestionCoordinatorProtocol {
    
    public var navigationController: UINavigationController
    
    public init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    public func start() {
        let vc: SuggestionViewController = InvestDIContainer.shared.resolve()
        vc.coordinator = self
        navigationController.push(vc)
    }
    
    public func pushSuggestionDetailViewController(postId: Int) {
        let vc: SuggestionDetailViewController = InvestDIContainer.shared.resolve()
        vc.postId = postId
        navigationController.push(vc)
    }
}

