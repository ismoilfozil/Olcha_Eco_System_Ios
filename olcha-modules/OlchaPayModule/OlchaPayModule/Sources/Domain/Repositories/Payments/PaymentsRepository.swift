//
//  PaymentsRepository.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 27/03/23.
//

import Foundation
import Combine
import OlchaCore

public protocol PaymentsRepositoryProtocol {
    
    func loadProviders(categoryID: Int, page: Int) -> AnyPublisher<(BaseResponse<ProvidersData, EmptyData>), Never>
    
    func loadCategories() -> AnyPublisher<(BaseResponse<CategoriesData, EmptyData>), Never>
    
    func loadProvider(serviceID: Int) -> AnyPublisher<(BaseResponse<ProviderData, EmptyData>), Never>
    
    func loadProvider(providerID: Int) -> AnyPublisher<(BaseResponse<ProviderData, EmptyData>), Never>
    
    func loadPhoneCodes() -> AnyPublisher<(BaseResponse<PhoneCodesData, EmptyData>), Never>
}

public class PaymentsRepository: BaseRepository, PaymentsRepositoryProtocol {
    public func loadProviders(categoryID: Int, page: Int) -> AnyPublisher<(BaseResponse<ProvidersData, EmptyData>), Never> {
        let api: PaymentsAPI = .providers(categoryID: categoryID, page: page)
        return manager.request(api: api,
                               isSingleRequest: false,
                               isCancellable: false)
    }
    
    public func loadCategories() -> AnyPublisher<(BaseResponse<CategoriesData, EmptyData>), Never> {
        let api: PaymentsAPI = .categories
        return manager.request(api: api,
                               isSingleRequest: false,
                               isCancellable: false)
    }
    
    public func loadProvider(serviceID: Int) -> AnyPublisher<(BaseResponse<ProviderData, EmptyData>), Never> {
        let api: PaymentsAPI = .provider(serviceID: serviceID)
        return manager.request(api: api)
    }
    
    public func loadProvider(providerID: Int) -> AnyPublisher<(BaseResponse<ProviderData, EmptyData>), Never> {
        let api: PaymentsAPI = .providerById(id: providerID)
        return manager.request(api: api)
    }
    
    public func loadPhoneCodes() -> AnyPublisher<(BaseResponse<PhoneCodesData, EmptyData>), Never> {
        
        if let cache = PayGlobalDefaults.cache.phoneCodes.cachedPhoneCodes() {
            return Future { promise in
                
                DispatchQueue.main.async {
                    promise(.success(.init(status: .success,
                                           error: nil,
                                           response: cache,
                                           code: 200,
                                           errors: nil)))
                }
            }.eraseToAnyPublisher()
        } else {
            let api: PaymentsAPI = .phoneCodes
            
            return manager.request(api: api,
                                   isSingleRequest: false,
                                   isCancellable: false)
        }
    }
}
