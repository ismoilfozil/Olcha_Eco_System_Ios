//
//  CatalogPageViewModel.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 05/07/22.
//

import Foundation
import Combine
import OlchaUI
import OlchaCore
import OlchaAuth
public class CatalogPageViewModel: OldBaseViewModel {
    
    //MARK: - RESPONSES
    @Published var products: ProductsData?
    @Published var oftenNeeded: ProductsData?
    @Published var sale: ProductsData?
    @Published var popular: ProductsData?
    @Published var monthly: ProductsData?
    @Published var new: ProductsData?
    @Published var similar: LoadingState<ProductsData, BaseErrorType> = .standart
    @Published var analog: LoadingState<ProductsData, BaseErrorType> = .standart
    @Published var alsoSeen: ProductsData?
    @Published var dailyProducts: ProductsData?
    @Published var categories: CatData?
    @Published var brands:  ManufacturersData?
    @Published var sliders: SlidersData?
    @Published var category: CategoryModel?
    @Published var routeProducts: (Int, ProductsData?)?
    @Published var routeCategories: (Int, CatData?)?
    @Published var routeBrands: (Int, ManufacturersData?)?
    @Published var builderErrorIndex: Int?
    
    //MARK: - INDICATORS
    let productSkeletonIndicator = CurrentValueSubject<Bool, Never>(false)
    let productsIndicator = CurrentValueSubject<Bool, Never>(false)
    let categoriesIndicator = CurrentValueSubject<Bool, Never>(false)
    let dailyProductIndicator = CurrentValueSubject<Bool, Never>(false)
    let filterProductsIndicator = CurrentValueSubject<Bool, Never>(false)
    let categoryIndicator = CurrentValueSubject<Bool, Never>(false)
    //MARK: - ERRORS
    var productsError = CurrentValueSubject<Bool, Never>(false)
    
    init() {
        super.init(manager: OlchaDIContainer.shared.resolve())
    }
    
    func loadProducts(with type: ProductsType = .none,
                      similarity: ProductSimilarity = .none,
                      filters: ProductListFilters = .init()) {
        filters.productsType = type
        filters.similarity = similarity
        switch similarity {
        case .analog:
            self.similar = .loading
        case .similar:
            self.analog = .loading
        default: break
        }
        
        let api: CatalogAPI = .categoryProducts(filters: filters)
        self.startRequesting(api: api, indicator: filterProductsIndicator) { [weak self] (data: ProductsData?) in
            guard let self = self else { return }
            guard let data = data else { return }
            
            switch type {
            case .often_needed:
                self.oftenNeeded = data
                break
            case .is_sale:
                self.sale = data
                break
            case .popular:
                self.popular = data
                break
            case .has_installment:
                self.monthly = data
                break
            case .is_new:
                self.new = data
                break
            default: break
            }
            
            switch similarity {
                
            case .similar:
                self.similar = .success(data)
                break
            case .analog:
                self.analog = .success(data)
                break
            case .alsoSeen:
                self.alsoSeen = data
            default: break
            }
        } onError: { [weak self] message in
            guard let self = self else { return }
            self.show(error: message)
            switch similarity {
            case .analog:
                self.similar = .failure(.init(message: message))
            case .similar:
                self.analog = .failure(.init(message: message))
            default: break
            }
        }
    }
    
    func loadCategoryProducts(filters: ProductListFilters) {
        
        if filters.paging.current == 1 {
            productSkeletonIndicator.send(true)
        } else {
//            productsIndicator.send(true)
        }
        
        let api: CatalogAPI = .categoryProducts(filters: filters)
        self.startRequesting(api: api) { [weak self] (data: ProductsData?) in
            guard let self = self else { return }
            if filters.paging.current == 1 {
                self.productSkeletonIndicator.send(false)
            } else {
//                self.productsIndicator.send(false)
            }

            var modifiedData = data
            modifiedData?.category = filters.category
            
            self.products = modifiedData
            
        } onError: { [weak self] message in
            guard let self = self else { return }
            if filters.paging.current == 1 {
                self.productSkeletonIndicator.send(false)
            } else {
//                self.productsIndicator.send(false)
            }
            
            self.show(error: message)
            self.productsError.send(true)
        }
        
    }
    
    func loadCategories(withIndicator: Bool = true) {
        let api: CatalogAPI = .categories
        
        self.startRequesting(api: api, centerLoader: false,
                             indicator: withIndicator ? categoriesIndicator : nil) { [weak self] (data: CatData?) in
            guard let self = self else { return }
            self.categories = data
        }
    }
    
    func loadCategorySliders(alias: String) {
        
        let api: CatalogAPI = .sliders(alias: alias)
        
        self.startRequesting(api: api) { [weak self] (data: SlidersData?) in
            guard let self = self else { return }
            self.sliders = data
        }
    }
    
    func loadCategoryBrands() {
        let api: CatalogAPI = .brands
        
        self.startRequesting(api: api) { [weak self] (data: ManufacturersData?) in
            guard let self = self else { return }
            self.brands = data
        }
    }
    
    func loadDailyProducts(withIndicator: Bool = true) {
        let api: CatalogAPI = .dailyProducts
        
        self.startRequesting(api: api, indicator: withIndicator ? dailyProductIndicator : nil) { [weak self] (data: ProductsData?) in
            guard let self = self else { return }
            self.dailyProducts = data
        }
    }
    
    func loadRouteProducts(index: Int, filter: ProductListFilters) {
        let api: CatalogAPI = .categoryProducts(filters: filter)
        self.startRequesting(api: api) { [weak self] (data: ProductsData?) in
            guard let self = self else { return }
            self.routeProducts = (index, data)
        } onError: { [weak self] msg in
            guard let self = self else { return }
            self.show(error: msg)
            self.builderErrorIndex = index
        }
    }
    
    func loadCategories(index: Int, route: String) {
        let api: RouteAPI = .route(api: route)
        self.startRequesting(api: api, indicator: categoriesIndicator) { [weak self] (data: CatData?) in
            guard let self = self else { return }
            self.routeCategories = (index, data)
        } onError: { [weak self] msg in
            guard let self = self else { return }
            self.show(error: msg)
            self.builderErrorIndex = index
        }
    }
    
    func loadBrands(index: Int, route: String) {
        let api: RouteAPI = .route(api: route)
        self.startRequesting(api: api) { [weak self] (data: ManufacturersData?) in
            guard let self = self else { return }
            self.routeBrands = (index, data)
        } onError: { [weak self] msg in
            guard let self = self else { return }
            self.show(error: msg)
            self.builderErrorIndex = index
        }
    }
    
    func loadCategory(with alias: String) {
        let api: CatalogAPI = .category(alias: alias)
        self.startRequesting(api: api, indicator: categoryIndicator) { [weak self] (data: CategoryData?) in
            guard let self = self else { return }
            self.category = data?.category
        }
    }
    
    func searchCategory(with text: String) {
        let api: CatalogAPI = .searchCategories(search: text)
        self.startRequesting(api: api) { [weak self] (data: CatData?) in
            guard let self = self else { return }
            self.categories = data
        }
    }
    
    func loadCategories(manufacturer: String?) {
        guard let manufacturer = manufacturer else { return }
        let api: CatalogAPI = .categoriesWithManufacturer(manufacturer: manufacturer)
        self.startRequesting(api: api) { [weak self] (data: CatData?) in
            guard let self = self else { return }
            self.categories = data
        }
    }
}
