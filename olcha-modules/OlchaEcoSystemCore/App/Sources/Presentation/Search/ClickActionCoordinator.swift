//
//  ClickActionCoordinator.swift
//  OlchaEcoSystemCore
//
//  Created by Elbek Khasanov on 27/10/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import Foundation
import OlchaUI
import OlchaUtils

public protocol ClickActionCoordinatorProtocol: Coordinator {
    func clickActionRouter(action: ClickAction)
}

public class ClickActionCoordinator: EcoMainCoordinator, ClickActionCoordinatorProtocol {
    
    public var waitTime: TimeInterval = 0
    
    public func clickActionRouter(action: ClickAction) {
        if let module = action.module {
            ModuleGeneratorHelper.shared.generate(module: module) { [weak self] in
                guard let self else { return }
                DispatchQueue.main.asyncAfter(deadline: .now() + waitTime) {
                    let coordinator: AppCoordinatorProtocol? = ModuleGeneratorHelper.shared.getModuleCoordinator(module: module)
                    coordinator?.clickActionRouter(action: action)
                }
            }
        }
        
        if let action = action as? WebviewClickAction {
            switch action {
            case .webview(let deeplink):
                FuncsManager.openURL(deeplink)
            }
        }
    }
    
}
