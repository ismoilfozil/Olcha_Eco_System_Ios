//
//  SafetyAssembly.swift
//  OlchaCommon
//
//  Created by Elbek Khasanov on 09/10/23.
//

import UIKit
import Swinject
import OlchaUtils
import OlchaAuth

public final class SafetyAssembly: Assembly {

    public func assemble(container: Container) {

        container.register(SafetyViewController.self) { r in
            let viewModel: ProfileViewModel = AuthDIContainer.shared.resolve()
            return SafetyViewController(viewModel: viewModel)
        }
    }
    
}

