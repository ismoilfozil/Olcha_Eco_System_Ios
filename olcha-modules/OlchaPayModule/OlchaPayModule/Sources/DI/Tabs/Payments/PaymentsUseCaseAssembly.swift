//
//  PaymentsUseCaseAssembly.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 27/03/23.
//

import Foundation
import Swinject
final class PaymentsUseCaseAssembly: Assembly {
    func assemble(container: Container) {
        
        container.register(LoadCategoriesProtocol.self) { r in
            let repository = r.resolve(PaymentsRepositoryProtocol.self)!
            return PaymentsUseCase.LoadCategories(repository: repository)
        }
        
        container.register(LoadProvidersWithCategoryProtocol.self) { r in
            let repository = r.resolve(PaymentsRepositoryProtocol.self)!
            return PaymentsUseCase.LoadProvidersWithCategory(repository: repository)
        }
        
        container.register(LoadProviderProtocol.self) { r in
            let repository = r.resolve(PaymentsRepositoryProtocol.self)!
            return PaymentsUseCase.LoadProvider(repository: repository)
        }
        
        container.register(LoadProviderByIdProtocol.self) { r in
            let repository = r.resolve(PaymentsRepositoryProtocol.self)!
            return PaymentsUseCase.LoadProviderById(repository: repository)
        }
        
        container.register(LoadPhoneCodesProtocol.self) { r in
            let repository = r.resolve(PaymentsRepositoryProtocol.self)!
            return PaymentsUseCase.LoadPhoneCodes(repository: repository)
        }
        
        
    }
}
