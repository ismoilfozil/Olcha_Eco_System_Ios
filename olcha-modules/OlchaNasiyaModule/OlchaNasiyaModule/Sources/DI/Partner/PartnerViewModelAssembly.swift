//
//  PartnerViewModelAssembly.swift
//  OlchaNasiyaModule
//
//  Created by Elbek Khasanov on 18/05/23.
//

import Foundation
import Swinject
final class PartnerViewModelAssembly: Assembly {
    func assemble(container: Container) {
        container.register(PartnerViewModel.self) { r in
            let loadPartnersUseCase = r.resolve(LoadPartnersProtocol.self)!
            let loadPartnerUseCase = r.resolve(LoadPartnerProtocol.self)!
            let loadRegionsUseCase = r.resolve(LoadRegionsProtocol.self)!
            let loadCategoriesUseCase = r.resolve(LoadCategoriesProtocol.self)!
            return PartnerViewModel(loadPartnersUseCase: loadPartnersUseCase,
                                    loadPartnerUseCase: loadPartnerUseCase,
                                    loadRegionsUseCase: loadRegionsUseCase,
                                    loadCategoriesUseCase: loadCategoriesUseCase)
        }
    }
}
