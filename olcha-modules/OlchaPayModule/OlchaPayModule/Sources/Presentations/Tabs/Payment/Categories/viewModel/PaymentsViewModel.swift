//
//  PaymentsViewModel.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 27/03/23.
//

import Foundation
import OlchaUI
import OlchaCore
public class PaymentsViewModel: BaseViewModel {
    
    @Published var categories: LoadingState<CategoriesData, BaseErrorType> = .standart
    
    @Published var providersWithCategory: LoadingState<ProvidersData, BaseErrorType> = .standart
    
    @Published var provider: LoadingState<ProviderData, BaseErrorType> = .standart
    
    @Published var phoneCodes: LoadingState<PhoneCodesData, BaseErrorType> = .standart
    
    private let loadProviderUseCase: LoadProviderProtocol
    private let loadProviderByIdUseCase: LoadProviderByIdProtocol
    private let loadCategoriesUseCase: LoadCategoriesProtocol
    private let loadProvidersWithCategoryUseCase: LoadProvidersWithCategoryProtocol
    private let loadPhoneCodesUseCase: LoadPhoneCodesProtocol
    
    public init(loadCategoriesUseCase: LoadCategoriesProtocol,
                loadProviderByIdUseCase: LoadProviderByIdProtocol,
                loadProvidersWithCategoryUseCase: LoadProvidersWithCategoryProtocol,
                loadProviderUseCase: LoadProviderProtocol,
                loadPhoneCodesUseCase: LoadPhoneCodesProtocol
    ) {
        self.loadCategoriesUseCase = loadCategoriesUseCase
        self.loadProviderByIdUseCase = loadProviderByIdUseCase
        self.loadProvidersWithCategoryUseCase = loadProvidersWithCategoryUseCase
        self.loadProviderUseCase = loadProviderUseCase
        self.loadPhoneCodesUseCase = loadPhoneCodesUseCase
    }
    
    func loadCategories() {
        categories = .loading
        
        loadCategoriesUseCase.execute()
            .sink { [weak self] baseResponse in
                guard let self = self else { return }
                switch baseResponse.status {
                case .success:
                    self.categories = .success(baseResponse.response)
                default:
                    self.categories = .failure(.init(message: baseResponse.error))
                }
                categories = .standart
            }.store(in: &bag)
    }
    
    func loadProviders(category: CategoryModel?, page: Int) {
        guard let id = category?.id else { return }
        
        providersWithCategory = .loading
        
        loadProvidersWithCategoryUseCase.execute(categoryID: id, page: page)
            .sink { [weak self] baseResponse in
                guard let self = self else { return }
                switch baseResponse.status {
                case .success:
                    self.providersWithCategory = .success(baseResponse.response)
                    break
                default:
                    self.providersWithCategory = .failure(.init(message: baseResponse.error))
                    break
                }
                self.providersWithCategory = .standart
            }.store(in: &bag)
    }
    
    func loadProvider(id: Int) {
        provider = .loading
        
        loadProviderByIdUseCase.execute(providerId: id)
            .sink { [weak self] baseResponse in
                guard let self = self else { return }
                switch baseResponse.status {
                case .success:
                    provider = .success(baseResponse.response)
                    break
                default:
                    provider = .failure(.init(message: baseResponse.error))
                    break
                }
                provider = .standart
            }.store(in: &bag)
    }
    
    func loadProvider(serviceID: Int) {
        provider = .loading
        loadProviderUseCase.execute(serviceID: serviceID)
            .sink { [weak self] baseResponse in
                guard let self = self else { return }
                switch baseResponse.status {
                case .success:
                    self.provider = .success(baseResponse.response)
                    break
                default:
                    self.provider = .failure(.init(message: baseResponse.error))
                    break
                }
                self.provider = .standart
            }.store(in: &bag)
    }
    
    func loadPhoneCodes() {
        phoneCodes = .loading
        loadPhoneCodesUseCase.execute()
            .sink { [weak self] baseResponse in
                guard let self = self else { return }
                switch baseResponse.status {
                case .success:
                    self.phoneCodes = .success(baseResponse.response)
                    PayGlobalDefaults.cache.phoneCodes.cachePhoneCode(baseResponse.response)
                    break
                default:
                    self.phoneCodes = .failure(.init(message: baseResponse.error))
                    break
                }
                phoneCodes = .standart
            }.store(in: &bag)
    }
}
