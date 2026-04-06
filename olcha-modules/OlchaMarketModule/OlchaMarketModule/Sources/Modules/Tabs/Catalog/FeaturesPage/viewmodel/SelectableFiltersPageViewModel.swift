//
//  SelectableFiltersPageViewModel.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 22/08/22.
//

import Foundation
class SelectableFiltersPageViewModel {
    func convertManufacturers(values: [Manufacturer], filters: ProductListFilters?) {
        for i in 0..<values.count {
            if let row = filters?.manufacturers.firstIndex(where: { $0.id == values[i].id }) {
                filters?.manufacturers[row] = values[i]
            }
        }
    }
    
    func convertTags(values: [TagModel], filters: ProductListFilters?) {
        for i in 0..<values.count {
            if let row = filters?.tags.firstIndex(where: { $0.slug == values[i].slug }) {
                filters?.tags[row] = values[i]
            }
        }
    }
    
    func convertFeatures(section: Int, values: [ FeatureValue ], filters: ProductListFilters?) {
        
        for i in 0..<(values.count) {
            if let row = filters?.features[section].values?.firstIndex(where: { $0.id == values[i].id }) {
                filters?.features[section].values?[row] = values[i]
            }
        }
        
    }
}
