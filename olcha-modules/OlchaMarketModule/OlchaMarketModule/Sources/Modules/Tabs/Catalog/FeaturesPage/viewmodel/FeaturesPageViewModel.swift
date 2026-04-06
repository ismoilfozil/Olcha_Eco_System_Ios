//
//  FeaturesPageViewModel.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 13/07/22.
//

import Foundation
import Combine
import OlchaUI
import OlchaAuth
import OlchaCore
class FeaturesPageViewModel: OldBaseViewModel {
    
    @Published var features: FeaturesData?
    @Published var tags: TagData?
    @Published var featuresUpdated: Bool = false
    
    init() {
        super.init(manager: OlchaDIContainer.shared.resolve())
    }
    
    ///copy filters to mock
    func cloneFilters(filters: ProductListFilters?) -> ProductListFilters? {
        return filters?.copy()
    }
    
    func convertToOriginal(filters: ProductListFilters?, mockFilters: ProductListFilters?, withObservers: Bool = true) {
        filters?.similarity = mockFilters?.similarity ?? .none
        filters?.selectedSort = mockFilters?.selectedSort ?? .new
        filters?.cellType = mockFilters?.cellType ?? .shrink
        filters?.paging = mockFilters?.paging ?? .init()
        filters?.filterPrice = mockFilters?.filterPrice ?? .init()
        filters?.category = mockFilters?.category
        filters?.features = mockFilters?.features ?? []
        if withObservers {
            filters?.observers = mockFilters?.observers ?? .init()
        }
        filters?.manufacturers = mockFilters?.manufacturers ?? []
        filters?.tags = mockFilters?.tags ?? []
        filters?.discountID = mockFilters?.discountID
    }
    
    func loadFeatures(with categoryAlias: String) {
        let api: FeaturesAPI = .features(categoryAlias: categoryAlias)
        
        self.startRequesting(api: api, centerLoader: true) { [weak self] (data: FeaturesData?) in
            guard let self = self else { return }
            self.features = data
        }
    }
    
    func loadTags(with categoryAlias: String) {
        let api: FeaturesAPI = .tags(categoryAlias: categoryAlias)
        
        self.startRequesting(api: api, centerLoader: true) { [weak self] (data: TagData?) in
            guard let self = self else { return }
            self.tags = data
        }
    }
    
    func loadFilteredFeatures(categoryAlias: String, filters: ProductListFilters, isManufacturer: Bool) {
        
        let group = DispatchGroup()
        
        self.centerLoading = true
        
        filterFeatureQueue(categoryAlias: categoryAlias, filters: filters, group: group)
        
        if !isManufacturer {
            filterManufacturerQueue(filters: filters, group: group)
        }
        
        group.notify(queue: DispatchQueue.main) { [weak self] in
            guard let self = self else { return }
            self.centerLoading = false
            self.featuresUpdated = true
        }
    }
    
    
}

private extension FeaturesPageViewModel {
    
    func filterFeatureQueue(categoryAlias: String, filters: ProductListFilters, group: DispatchGroup) {
        group.enter()
        let api: FeaturesAPI = .filterFeatures(categoryAlias: categoryAlias, filters: filters)
        
        self.startRequesting(api: api) { [weak self] (data: FeaturesData?) in
            guard let self = self else { return }
            self.disableFeatures(filters: filters, newFeatures: data?.features ?? [])
            self.featuresUpdated = true
            group.leave()
        } onError: { [weak self] message in
            guard let self = self else { return }
            self.show(error: message)
            group.leave()
        }
    }
    
    func filterManufacturerQueue(filters: ProductListFilters, group: DispatchGroup) {
        group.enter()
        let api: FeaturesAPI = .filterManufacturers(filters: filters)
        
        self.startRequesting(api: api) { [weak self] (data: FeaturesData?) in
            guard let self = self else { return }
            self.disableManufacturers(filters: filters, newManufacturers: data?.manufacturers ?? [])
            group.leave()
        } onError: { [weak self] message in
            guard let self = self else { return }
            self.show(error: message)
            group.leave()
        }
    }
    
    func disableFeatures(filters: ProductListFilters, newFeatures: [FeatureData]) {
        
        for i in 0..<min((filters.features.count), (newFeatures.count)) {
            for k in 0..<(filters.features[i].values?.count ?? 0) {
                if newFeatures[i].values?.firstIndex(where: { $0.id == filters.features[i].values?[k].id }) != nil {
                    filters.features[i].values?[k].isEnabled = true
                } else {
                    filters.features[i].values?[k].isEnabled = false
                    filters.features[i].values?[k].isSelected = false
                }
            }
        }

    }
    
    func disableManufacturers(filters: ProductListFilters, newManufacturers: [Manufacturer]) {
        
        for i in 0..<(filters.manufacturers.count) {
            if newManufacturers.firstIndex(where: { $0.id == filters.manufacturers[i].id }) != nil {
                filters.manufacturers[i].isEnabled = true
            } else {
                filters.manufacturers[i].isEnabled = false
                filters.manufacturers[i].isSelected = false
            }
        }
    }

}
