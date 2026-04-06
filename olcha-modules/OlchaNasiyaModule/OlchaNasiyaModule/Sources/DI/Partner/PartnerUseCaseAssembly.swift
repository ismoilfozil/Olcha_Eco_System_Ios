//
//  PartnerUseCaseAssembly.swift
//  OlchaNasiyaModule
//
//  Created by Elbek Khasanov on 18/05/23.
//

import Foundation
import Swinject
final class PartnerUseCaseAssembly: Assembly {
    func assemble(container: Container) {
        container.register(LoadPartnersProtocol.self) { r in
            let repository = r.resolve(PartnerRepositoryProtocol.self)!
            return PartnerUseCase.LoadPartners(repository: repository)
        }
        
        container.register(LoadPartnerProtocol.self) { r in
            let repository = r.resolve(PartnerRepositoryProtocol.self)!
            return PartnerUseCase.LoadPartner(repository: repository)
        }
        
        container.register(LoadRegionsProtocol.self) { r in
            let repository = r.resolve(PartnerRepositoryProtocol.self)!
            return PartnerUseCase.LoadRegions(repository: repository)
        }
        
        container.register(LoadCategoriesProtocol.self) { r in
            let repository = r.resolve(PartnerRepositoryProtocol.self)!
            return PartnerUseCase.LoadCategories(repository: repository)
        }
    }
}
