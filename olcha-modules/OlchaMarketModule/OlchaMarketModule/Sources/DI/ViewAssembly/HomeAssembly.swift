//
//  HomeAssembly.swift
//  OlchaMarketModule
//
//  Created by Elbek Khasanov on 14/11/23.
//

import Swinject
import OlchaUtils
import OlchaUI
final class HomeAssembly: Assembly {
    func assemble(container: Swinject.Container) {
        container.register(WebPage.self) { r in
            WebPage()
        }
    }
}
