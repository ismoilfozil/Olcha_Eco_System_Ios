//
//  ProductsListAssembly.swift
//  OlchaMarketModule
//
//  Created by Elbek Khasanov on 14/11/23.
//

import Swinject
import OlchaUtils

final class ProductsListAssembly: Assembly {
    func assemble(container: Swinject.Container) {
        container.register(FavouritesPage.self) { r in
            FavouritesPage()
        }
        
        container.register(ComparePage.self) { r in
            ComparePage()
        }
    }
}
