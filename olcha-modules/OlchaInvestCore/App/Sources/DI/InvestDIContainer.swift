//
//  InvestDIContainer.swift
//  OlchaInvestCore
//
//  Created by Akhrorkhuja on 17/05/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import OlchaUI
import OlchaUtils
import OlchaVerification
import UIKit

public class InvestDIContainer: DIResolver {
    
    public static let shared: InvestDIContainer = .init()
    
    public override init() {
        super.init()
        
        assembler.apply(assemblies: [
            AppAssembly(),
            RepositoryAssembly(),
            UseCaseAssembly(),
            SceneAssembly(),
            CommonAssembly(),
            MenuViewAssembly(),
        ])
        registerExtraAssemblies()
    }
    
    public func registerExtraAssemblies() {
        OlchaVerificationDIContainer.shared.container.register(
            VerificationCoordinatorProtocol.self,
            name: BackVerificationCoordinator.classIdentifier) { (r, navigationController: UINavigationController) in
            return BackVerificationCoordinator(navigationController: navigationController)
        }
        
        OlchaVerificationDIContainer.shared.container.register(
            VerificationCoordinatorProtocol.self,
            name: VerificationCoordinator.classIdentifier) { (r, navigationController: UINavigationController) in
            return VerificationCoordinator(navigationController: navigationController)
        }
    }
    
}
