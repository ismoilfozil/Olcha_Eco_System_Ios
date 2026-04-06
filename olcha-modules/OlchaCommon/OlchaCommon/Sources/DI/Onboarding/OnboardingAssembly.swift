//
//  OnboardingAssembly.swift
//  OlchaCommon
//
//  Created by Elbek Khasanov on 10/10/23.
//

import UIKit
import Swinject
import OlchaUtils

public final class OnboardingAssembly: Assembly {
    public func assemble(container: Container) {
        container.register(OnboardingViewController.self) { r in
            return OnboardingViewController()
        }
        
        container.register(OnboardingLanguageModalViewController.self) { r in
            return OnboardingLanguageModalViewController()
        }
    }
}

