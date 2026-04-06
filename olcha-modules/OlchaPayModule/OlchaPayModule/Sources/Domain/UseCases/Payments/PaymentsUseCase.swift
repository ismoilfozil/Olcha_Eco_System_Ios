//
//  PaymentsUseCase.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 27/03/23.
//

import Foundation
import OlchaCore
import Combine

public protocol LoadProviderProtocol {
    func execute(serviceID: Int) -> AnyPublisher<BaseResponse<ProviderData, EmptyData>, Never>
}

public protocol LoadProviderByIdProtocol {
    func execute(providerId: Int) -> AnyPublisher<BaseResponse<ProviderData, EmptyData>, Never>
}

public protocol LoadCategoriesProtocol {
    func execute() -> AnyPublisher<BaseResponse<CategoriesData, EmptyData>, Never>
}

public protocol LoadProvidersWithCategoryProtocol {
    func execute(categoryID: Int, page: Int) -> AnyPublisher<BaseResponse<ProvidersData, EmptyData>, Never>
}

public protocol LoadPhoneCodesProtocol {
    func execute() -> AnyPublisher<BaseResponse<PhoneCodesData, EmptyData>, Never>
}

public enum PaymentsUseCase {
    public class LoadCategories: LoadCategoriesProtocol {
       
        private let repository: PaymentsRepositoryProtocol
        
        public init(repository: PaymentsRepositoryProtocol) {
            self.repository = repository
        }
        
        public func execute() -> AnyPublisher<BaseResponse<CategoriesData, EmptyData>, Never> {
            repository.loadCategories()
        }
        
    }
    
    public class LoadProvidersWithCategory: LoadProvidersWithCategoryProtocol {
       
        private let repository: PaymentsRepositoryProtocol
        
        public init(repository: PaymentsRepositoryProtocol) {
            self.repository = repository
        }
        
        public func execute(categoryID: Int, page: Int) -> AnyPublisher<BaseResponse<ProvidersData, EmptyData>, Never> {
            repository.loadProviders(categoryID: categoryID, page: page)
        }
    }
    
    public class LoadProvider: LoadProviderProtocol {
       
        private let repository: PaymentsRepositoryProtocol
        
        public init(repository: PaymentsRepositoryProtocol) {
            self.repository = repository
        }
        
        public func execute(serviceID: Int) -> AnyPublisher<BaseResponse<ProviderData, EmptyData>, Never> {
            repository.loadProvider(serviceID: serviceID)
        }
    }
    
    public class LoadProviderById: LoadProviderByIdProtocol {
       
        private let repository: PaymentsRepositoryProtocol
        
        public init(repository: PaymentsRepositoryProtocol) {
            self.repository = repository
        }
        
        public func execute(providerId: Int) -> AnyPublisher<BaseResponse<ProviderData, EmptyData>, Never> {
            repository.loadProvider(providerID: providerId)
        }
    }
    
    public class LoadPhoneCodes: LoadPhoneCodesProtocol {
        
        private let repository: PaymentsRepositoryProtocol
        
        public init(repository: PaymentsRepositoryProtocol) {
            print("use case git")
            self.repository = repository
        }
        
        public func execute() -> AnyPublisher<BaseResponse<PhoneCodesData, EmptyData>, Never> {
            repository.loadPhoneCodes()
        }
    }
}
