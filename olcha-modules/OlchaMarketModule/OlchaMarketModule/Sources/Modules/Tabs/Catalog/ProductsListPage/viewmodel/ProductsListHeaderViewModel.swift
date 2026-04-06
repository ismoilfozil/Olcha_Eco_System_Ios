//
//  ProductsListHeaderViewModel.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 13/07/22.
//

import Foundation
class ProductsListHeaderViewModel {
    func checkPriceCellStatus(filters: ProductListFilters?) -> Bool {
        (filters?.filterPrice.min != nil) || (filters?.filterPrice.max != nil)
    }
    
    func checkFeaturCellStatus(filters: ProductListFilters?, at index: Int) -> Bool {
        let feature = filters?.features[index]
        for i in 0..<(feature?.values?.count ?? 0) {
            if (feature?.values?[i].isSelected ?? false) && (feature?.values?[i].isEnabled ?? true) { return true }
        }
        return false
    }
    
    func checkManufacturersCellStatus(filters: ProductListFilters?) -> Bool {
        for i in 0..<(filters?.manufacturers.count ?? 0) {
            if (filters?.manufacturers[i].isSelected ?? false) && (filters?.manufacturers[i].isEnabled ?? true) { return true }
        }
        return false
    }
    
    func checkTagsCellStatus(filters: ProductListFilters?, index: Int) -> Bool {
        return (filters?.tags[index].isSelected ?? false) && (filters?.tags[index].isEnabled ?? true)
    }
    
    func cancelFilters(filters: ProductListFilters?, at index: Int) {
        for i in 0..<(filters?.features[index].values?.count ?? 0) {
            filters?.features[index].values?[i].isSelected = false
        }
        filters?.observers.filterSelected.send(true)
    }
    
    func cancelTag(filters: ProductListFilters?, at index: Int) {
        filters?.tags[index].isSelected = false
        filters?.observers.tagSelected.send(true)
    }
    
    func cancelManufacturers(filters: ProductListFilters?) {
        for i in 0..<(filters?.manufacturers.count ?? 0) {
            filters?.manufacturers[i].isSelected = false
        }
        filters?.observers.manufacturerSelected.send(true)
    }
    
    
}
