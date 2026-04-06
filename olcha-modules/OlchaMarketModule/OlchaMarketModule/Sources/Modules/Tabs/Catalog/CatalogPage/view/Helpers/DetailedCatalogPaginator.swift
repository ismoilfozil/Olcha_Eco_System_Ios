//
//  DetailedCatalogPaginator.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 18/12/22.
//
import OlchaCore
import Foundation
class DetailedCatalogPaginator {
    var initialReloaded = false
    
    var isReadyProducts = false
    
    var loadedCategoryProducts: [CategoryModel] = []
    
    var categories: [CategoryModel] = []
    
    var popularProducts: ProductsData?
    
    var sliders: SlidersData?
    
    var brands: ManufacturersData?
    
    var categoriesPaging = Paging()
    
    var brandsPaging = Paging(current: 0)
    
    func isCategoryProductsLoaded() -> Bool {
        categoriesPaging.isFinishedPaging
    }
    
}
