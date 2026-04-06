//
//  PaymentsViewModelAssembly.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 27/03/23.
//

import Foundation
import Swinject
final class PaymentsViewModelAssembly: Assembly {
    func assemble(container: Container) {
        
        container.register(PaymentsViewModel.self, name: "shared") { r in
            
            let loadProviderUseCase = r.resolve(LoadProviderProtocol.self)!
            let loadProviderByIdUseCase = r.resolve(LoadProviderByIdProtocol.self)!
            let loadCategoriesUseCase = r.resolve(LoadCategoriesProtocol.self)!
            let loadProvidersWithCategoryUseCase = r.resolve(LoadProvidersWithCategoryProtocol.self)!
            let loadPhoneCodesUseCase = r.resolve(LoadPhoneCodesProtocol.self)!
            
            return PaymentsViewModel(
                loadCategoriesUseCase: loadCategoriesUseCase,
                loadProviderByIdUseCase: loadProviderByIdUseCase,
                loadProvidersWithCategoryUseCase: loadProvidersWithCategoryUseCase,
                loadProviderUseCase: loadProviderUseCase,
                loadPhoneCodesUseCase: loadPhoneCodesUseCase
            )
        }.inObjectScope(.container)
        
        container.register(PaymentsViewModel.self) { r in
            
            let loadProviderUseCase = r.resolve(LoadProviderProtocol.self)!
            let loadProviderByIdUseCase = r.resolve(LoadProviderByIdProtocol.self)!
            let loadCategoriesUseCase = r.resolve(LoadCategoriesProtocol.self)!
            let loadProvidersWithCategoryUseCase = r.resolve(LoadProvidersWithCategoryProtocol.self)!
            let loadPhoneCodesUseCase = r.resolve(LoadPhoneCodesProtocol.self)!
            
            return PaymentsViewModel(
                loadCategoriesUseCase: loadCategoriesUseCase,
                loadProviderByIdUseCase: loadProviderByIdUseCase,
                loadProvidersWithCategoryUseCase: loadProvidersWithCategoryUseCase,
                loadProviderUseCase: loadProviderUseCase,
                loadPhoneCodesUseCase: loadPhoneCodesUseCase
            )
        }
    }
}
