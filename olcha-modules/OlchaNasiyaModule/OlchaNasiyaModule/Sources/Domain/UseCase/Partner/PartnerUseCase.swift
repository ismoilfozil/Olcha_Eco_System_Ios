//
//  PartnerUseCase.swift
//  OlchaNasiyaModule
//
//  Created by Elbek Khasanov on 18/05/23.
//
import Foundation
import OlchaCore
import Combine
public protocol LoadPartnersProtocol {
    func execute(filter: PartnerFilter, cancel: Bool) -> AnyPublisher<BaseResponse<PartnersData, EmptyData>, Never>
}

public protocol LoadPartnerProtocol {
    func execute(slug: String) -> AnyPublisher<BaseResponse<FullPartnerData, EmptyData>, Never>
}

public protocol LoadRegionsProtocol {
    func execute() -> AnyPublisher<BaseResponse<RegionsData, EmptyData>, Never>
}

public protocol LoadCategoriesProtocol {
    func execute() -> AnyPublisher<BaseResponse<CategoryData, EmptyData>, Never>
}

public enum PartnerUseCase {
    public class LoadPartners: LoadPartnersProtocol {
        
        private let repository: PartnerRepositoryProtocol
        
        public init(repository: PartnerRepositoryProtocol) {
            self.repository = repository
        }
        
        public func execute(filter: PartnerFilter, cancel: Bool) -> AnyPublisher<BaseResponse<PartnersData, EmptyData>, Never> {
            repository.loadPartners(filter: filter, cancel: cancel)
        }
    }
    
    public class LoadPartner: LoadPartnerProtocol {
        
        private let repository: PartnerRepositoryProtocol
        
        public init(repository: PartnerRepositoryProtocol) {
            self.repository = repository
        }
        
        public func execute(slug: String) -> AnyPublisher<BaseResponse<FullPartnerData, EmptyData>, Never> {
            repository.loadPartner(slug: slug)
        }
    }
    
    public class LoadRegions: LoadRegionsProtocol {
        
        private let repository: PartnerRepositoryProtocol
        
        public init(repository: PartnerRepositoryProtocol) {
            self.repository = repository
        }
        
        public func execute() -> AnyPublisher<BaseResponse<RegionsData, EmptyData>, Never> {
            repository.loadRegions()
        }
    }
    
    public class LoadCategories: LoadCategoriesProtocol {
        
        private let repository: PartnerRepositoryProtocol
        
        public init(repository: PartnerRepositoryProtocol) {
            self.repository = repository
        }
        
        public func execute() -> AnyPublisher<BaseResponse<CategoryData, EmptyData>, Never> {
            repository.loadCategories()
        }
    }
    
}
