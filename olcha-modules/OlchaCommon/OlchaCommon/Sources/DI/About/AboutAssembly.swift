//
//  AboutAssembly.swift
//  OlchaCommon
//
//  Created by ahrorxudja on 05/10/23.
//

import Swinject
import OlchaUtils

public final class AboutAssembly: Assembly {

    public func assemble(container: Container) {
        container.register(AboutViewController.self) { _ in
            return AboutViewController()
        }
    }
    
}
