//
//  ManagerAssembly.swift
//  OlchaEcoSystemCore
//
//  Created by Elbek Khasanov on 27/10/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import UIKit
import Swinject
import OlchaCore
import Alamofire

final class ManagerAssembly: Assembly {
 
    public func assemble(container: Container) {
        container.register(EcoSearchCoordinatorProtocol.self) { (r, navigationController: UINavigationController) in
            return EcoSearchCoordinator(navigationController: navigationController)
        }
        
        container.register(ClickActionCoordinatorProtocol.self) { (r, navigationController: UINavigationController) in
            return ClickActionCoordinator(navigationController: navigationController)
        }
        
        
    }
    
}
