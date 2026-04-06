//
//  PartnerViewModel.swift
//  OlchaNasiyaModule
//
//  Created by Elbek Khasanov on 18/05/23.
//

import OlchaUI
import Combine
import Foundation
import OlchaCore
public class PartnerViewModel: BaseViewModel {
    
    @Published public var stores: LoadingState<PartnersData, BaseErrorType> = .standart
    @Published public var partner: LoadingState<FullPartnerData, BaseErrorType> = .standart
    @Published public var regions: LoadingState<RegionsData, BaseErrorType> = .standart
    @Published public var categories: LoadingState<CategoryData, BaseErrorType> = .standart
    
    private let loadPartnersUseCase: LoadPartnersProtocol
    private let loadPartnerUseCase: LoadPartnerProtocol
    private let loadRegionsUseCase: LoadRegionsProtocol
    private let loadCategoriesUseCase: LoadCategoriesProtocol
    
    public init(loadPartnersUseCase: LoadPartnersProtocol,
                loadPartnerUseCase: LoadPartnerProtocol,
                loadRegionsUseCase: LoadRegionsProtocol,
                loadCategoriesUseCase: LoadCategoriesProtocol
    ) {
        self.loadPartnersUseCase = loadPartnersUseCase
        self.loadPartnerUseCase = loadPartnerUseCase
        self.loadRegionsUseCase = loadRegionsUseCase
        self.loadCategoriesUseCase = loadCategoriesUseCase
    }
    
    public func loadPartners(filter: PartnerFilter, cancel: Bool = false) {
        stores = .loading
        loadPartnersUseCase.execute(filter: filter, cancel: cancel)
            .sink { [weak self] baseResponse in
                guard let self = self else { return }
                switch baseResponse.status {
                case .success:
                    stores = .success(baseResponse.response)
                case .canceled: break
                default:
                    stores = .failure(.init(message: baseResponse.error))
                }
            }.store(in: &bag)
    }
    
    public func loadPartner(slug: String?) {
        guard let slug = slug, slug != "" else { return }
        partner = .loading

        loadPartnerUseCase.execute(slug: slug)
            .sink { [weak self] baseResponse in
                guard let self = self else { return }
                switch baseResponse.status {
                case .success:
                    partner = .success(baseResponse.response)
                default:
                    partner = .failure(.init(message: baseResponse.error))
                }
            }.store(in: &bag)
    }
    
    public func loadRegions(completion: (() -> Void)? = nil, forceLoad: Bool = false) {
        guard (regions.value == nil) || forceLoad else {
            completion?()
            return
        }
        
        regions = .loading
        
        loadRegionsUseCase.execute()
            .sink { [weak self] baseResponse in
                guard let self = self else { return }
                switch baseResponse.status {
                case .success:
                    regions = .success(baseResponse.response)
                default:
                    regions = .failure(.init(message: baseResponse.error))
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    completion?()
                }
            }.store(in: &bag)
    }
    
    public func loadCategories(completion: (() -> Void)? = nil, forceLoad: Bool = false) {
        guard categories.value == nil || forceLoad else {
            completion?()
            return
        }
        
        categories = .loading
        
        loadCategoriesUseCase.execute()
            .sink { [weak self] baseResponse in
                guard let self = self else { return }
                
                switch baseResponse.status {
                case .success:
                    categories = .success(baseResponse.response)
                default:
                    categories = .failure(.init(message: baseResponse.error))
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    completion?()
                }
            }.store(in: &bag)
    }
}
