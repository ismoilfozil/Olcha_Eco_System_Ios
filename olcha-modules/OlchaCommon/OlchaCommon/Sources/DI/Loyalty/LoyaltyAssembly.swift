//
//  LoyaltyAssembly.swift
//  OlchaCommon
//
//  Created by Elbek Khasanov on 06/07/24.
//

import Foundation
import Swinject

public final class LoyaltyAssembly: Assembly {

    public func assemble(container: Container) {
        container.register(NextLevelLoyaltyPage.self) { _ in
            return NextLevelLoyaltyPage()
        }
    }
    
}
