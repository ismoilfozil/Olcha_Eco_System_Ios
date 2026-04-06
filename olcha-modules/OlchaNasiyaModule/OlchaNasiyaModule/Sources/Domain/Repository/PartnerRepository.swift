//
//  PartnerRepository.swift
//  OlchaNasiyaModule
//
//  Created by Elbek Khasanov on 18/05/23.
//

import Foundation
import OlchaCore
import Combine
public protocol PartnerRepositoryProtocol {
    func loadPartners(filter: PartnerFilter, cancel: Bool) -> AnyPublisher<BaseResponse<PartnersData, EmptyData>, Never>
    func loadPartner(slug: String) -> AnyPublisher<BaseResponse<FullPartnerData, EmptyData>, Never>
    func loadRegions() -> AnyPublisher<BaseResponse<RegionsData, EmptyData>, Never>
    func loadCategories() -> AnyPublisher<BaseResponse<CategoryData, EmptyData>, Never>
}

public class PartnerRepository: BaseRepository, PartnerRepositoryProtocol {
    public func loadRegions() -> AnyPublisher<OlchaCore.BaseResponse<RegionsData, OlchaCore.EmptyData>, Never> {
        let api: PartnerAPI = .regions
        return manager.request(api: api)
    }
    
    public func loadPartners(filter: PartnerFilter, cancel: Bool) -> AnyPublisher<BaseResponse<PartnersData, EmptyData>, Never> {
        let api: PartnerAPI = .partners(filter: filter)
        return manager.request(api: api, isCancellable: cancel)
    }
    
    public func loadPartner(slug: String) -> AnyPublisher<BaseResponse<FullPartnerData, EmptyData>, Never> {
        let api: PartnerAPI = .partner(slug: slug)
        return manager.request(api: api)
    }
    
    public func loadCategories() -> AnyPublisher<BaseResponse<CategoryData, EmptyData>, Never> {
        let api: PartnerAPI = .categories
        return manager.request(api: api)
    }
}

public class PartnerMockRepository: PartnerRepositoryProtocol {
    public func loadRegions() -> AnyPublisher<OlchaCore.BaseResponse<RegionsData, OlchaCore.EmptyData>, Never> {
        fatalError()
    }
    
    public func loadCategories() -> AnyPublisher<BaseResponse<CategoryData, EmptyData>, Never> {
        fatalError()
    }
    
    public func loadPartners(filter: PartnerFilter, cancel: Bool) -> AnyPublisher<BaseResponse<PartnersData, EmptyData>, Never> {
        return Future { promise in
            promise(.success(
                .init(status: .success,
                      error: nil,
                      response: .mock(page: filter.partners.paging.current),
                      code: 200,
                      errors: nil)
            )
            )
        }.eraseToAnyPublisher()
    }
    
    public func loadPartner(slug: String) -> AnyPublisher<BaseResponse<FullPartnerData, EmptyData>, Never> {
        return Future { promise in
            promise(.success(.init(status: .success,
                                   error: nil,
                                   response: .mock(id: 1),
                                   code: 200,
                                   errors: nil)
                )
            )
        }.eraseToAnyPublisher()
    }
}
