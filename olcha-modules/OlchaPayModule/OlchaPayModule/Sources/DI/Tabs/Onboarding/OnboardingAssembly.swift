//
//  OnboardingAssebly.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 24/02/23.
//

import Foundation
import Swinject
import OlchaUI
final class OnboardingAssembly: Assembly {
    func assemble(container: Container) {
        
        container.register(OnboardingViewController.self) { r in
            return OnboardingViewController()
        }
        
    }
}
