//
//  DetailedCatalogViewModel.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 15/12/22.
//

import Foundation
import Combine
import OlchaUI
import OlchaCore
import OlchaAuth
class DetailedCatalogViewModel: OldBaseViewModel {
    
    //MARK: - Responses
    @Published var routeCategory: CategoryData?
    @Published var category: CategoryModel?
    
    //MARK: - Indicators
    let productsIndicator = CurrentValueSubject<Bool, Never>(false)
    let filterProductsIndicator = CurrentValueSubject<Bool, Never>(false)
    //MARK: - Errors
    
    @Published var categoryProducts: ProductsData?
    let productsPaginationError = PassthroughSubject<Bool, Never>()
    
    @Published var popular: ProductsData?
    let popularError = PassthroughSubject<Bool, Never>()
    
    @Published var sliders: SlidersData?
    let slidersError = PassthroughSubject<Bool, Never>()
    
    let brandsError = PassthroughSubject<Bool, Never>()
    @Published var brands:  ManufacturersData?
    
    let productsError = CurrentValueSubject<Bool, Never>(false)
    @Published var products: ProductsData?
    
    init() {
        super.init(manager: OlchaDIContainer.shared.resolve())
    }
    
    
    func loadCategory(route: String) {
        let api: RouteAPI = .route(api: route)
        self.startRequesting(api: api, centerLoader: true) { [weak self] (data: CategoryData?) in
            guard let self = self else { return }
            self.routeCategory = data
        }
    }
    
    func loadCategory(with alias: String) {
        let api: CatalogAPI = .category(alias: alias)
        self.startRequesting(api: api, centerLoader: true) { [weak self] (data: CategoryData?) in
            guard let self = self else { return }
            self.category = data?.category
        }
    }
    
    func loadCategoryProducts(filters: ProductListFilters) {
    
        let api: CatalogAPI = .categoryProducts(filters: filters)

        self.startRequesting(api: api) { [weak self] (data: ProductsData?) in
            guard let self = self else { return }

            var modifiedData = data
            modifiedData?.category = filters.category

            self.categoryProducts = modifiedData
            
        } onError: { [weak self] message in
            guard let self = self else { return }

            self.show(error: message)
            self.productsPaginationError.send(true)
        }
    }
    
    func loadProducts(with type: ProductsType = .none,
                      similarity: ProductSimilarity = .none,
                      filters: ProductListFilters = .init()) {
        
        filters.productsType = type
        filters.similarity = similarity
        let api: CatalogAPI = .categoryProducts(filters: filters)
        self.startRequesting(api: api,
                             centerLoader: true,
                             indicator: filterProductsIndicator) { [weak self] (data: ProductsData?) in
            guard let self = self else { return }
            guard let data = data else { return }

            switch type {
            case .popular:
                self.popular = data
                break
            default: break
            }
        } onError: { [weak self] message in
            guard let self = self else { return }
            self.show(error: message)
            self.popularError.send(true)
        }
    }
    
    func loadCategorySliders(alias: String) {
        
        let api: CatalogAPI = .sliders(alias: alias)
        
        self.startRequesting(api: api, centerLoader: true) { [weak self] (data: SlidersData?) in
            guard let self = self else { return }
            self.sliders = data
        } onError: { [weak self] message in
            guard let self = self else { return }
            self.show(error: message)
            self.slidersError.send(true)
        }
    }
    
    func loadCategoryBrands() {
        let api: CatalogAPI = .brands
        
        self.startRequesting(api: api) { [weak self] (data: ManufacturersData?) in
            guard let self = self else { return }
            self.brands = data
        } onError: { [weak self] message in
            guard let self = self else { return }
            self.show(error: message)
            self.brandsError.send(true)
        }
    }
    
    func loadProducts(filters: ProductListFilters) {
        
//        if filters.paging.current == 1 {
//            productsIndicator.send(true)
//        } else {
//            centerLoading = true
//        }
        
        let api: CatalogAPI = .categoryProducts(filters: filters)

        self.startRequesting(api: api) { [weak self] (data: ProductsData?) in
            guard let self = self else { return }
//            if filters.paging.current == 1 {
//                self.productsIndicator.send(false)
//            } else {
//                self.centerLoading = false
//            }

            var modifiedData = data
            modifiedData?.category = filters.category

            self.products = modifiedData
            
        } onError: { [weak self] message in
            guard let self = self else { return }
//            if filters.paging.current == 1 {
//                self.productsIndicator.send(false)
//            } else {
//                self.centerLoading = false
//            }

            self.show(error: message)
            self.productsError.send(true)
        }
    }
}
