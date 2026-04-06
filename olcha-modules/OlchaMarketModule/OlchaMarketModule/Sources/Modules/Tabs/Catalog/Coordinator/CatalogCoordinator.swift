//
//  CatalogCoordinator.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 06/07/22.
//


import UIKit
import Combine
import OlchaUI
public protocol CatalogCoordinatorProtocol: Coordinator {
    var selectedCatalogStack: [CategoryModel] { get set }
    
    
    func pushBrandProducts(filters: ProductListFilters)
    func pushProductPage(product: ProductModel?)
    func presentCategoryListFilterModal(filters: ProductListFilters?)
    func presentCategoryListForManufacturer(filters: ProductListFilters?)
    func pushProductsListPage(category: CategoryModel?,
                              brand: Manufacturer?,
                              catalogStack: [CategoryModel])
    
    func pushProductsList(filters: ProductListFilters)
    func pushCatalogListPage(pageState: DetailedCatalogListPage.InitialPageState)
    func pushDifferentCategoriesList(route: String)
    func pushSlider(_ slider: Slider?)
    
    func pushAllBrands()
    func pushSearch()
    func dismiss()
    
    func pushFavourites()
    func pushNotifications()
    func presentCartVariation(product: ProductModel?,
                              productType: ProductType)
}
public class CatalogCoordinator: OlchaMainCoordinator, CatalogCoordinatorProtocol {
    public var selectedCatalogStack: [CategoryModel]  = []
    
    public override func start() {
        let vc = MainCatalogPage()
        vc.coordinator = self
        navigationController.set([vc])
    }
    
    public func pushDifferentCategoriesList(route: String) {
        let vc = MainCatalogPage()
        vc.coordinator = self
        vc.sourceType = .route(api: route)
        navigationController.push(vc)
    }
    
    public func pushCatalogListPage(pageState: DetailedCatalogListPage.InitialPageState) {
        let vc = DetailedCatalogListPage()
        vc.coordinator = self
        vc.pageState = pageState
        navigationController.push(vc)
    }
    
    public func presentCategoryListFilterModal(filters: ProductListFilters?) {
        let vc = CatalogListPage()
        vc.catalogStack = filters?.catalogStack ?? []
        vc.category = filters?.category
        vc.coordinator = self
        navigationController.presentModally(vc)
    }
    
    public func presentCategoryListForManufacturer(filters: ProductListFilters?) {
        let vc = CatalogListPage()
        vc.catalogStack = filters?.catalogStack ?? []
        vc.category = filters?.category
        vc.brand = filters?.staticManufacturer
        vc.filters = filters
        vc.coordinator = self
        navigationController.presentModally(vc)
    }
    
    public func pushProductsListPage(category: CategoryModel?,
                                     brand: Manufacturer?,
                                     catalogStack: [CategoryModel] = []) {
        let filters = ProductListFilters()
        filters.category = category
        filters.catalogStack = catalogStack
        filters.selectedManufacturer = brand
        
        productCoordinator.pushProductsList(filters: filters)
    }
    
    public func pushProductPage(product: ProductModel?) {
        productCoordinator.pushProductPage(product: product)
    }
    
    public func pushProductsList(filters: ProductListFilters) {
        productCoordinator.pushProductsList(filters: filters)
    }
    
    public func pushBrandProducts(filters: ProductListFilters) {
        brandsCoordinator.pushBrandProducts(filters: filters)
    }
    
    public func pushSlider(_ slider: Slider?) {
        sliderCoordinator.pushSlider(slider)
    }
    
    public func dismiss() {
        navigationController.dismiss()
    }
    
    public func pushAllBrands() {
        brandsCoordinator.start()
    }
    
    public func pushSearch() {
        searchCoordinator.start()
    }
    
    public func pushFavourites() {
        profileCoordinator.pushFavourites(animated: true)
    }
    
    public func presentCartVariation(product: ProductModel?,
                                     productType: ProductType) {
        cartCoordinator.presentCartVariation(product: product,
                                             productType: productType)
    }
    
    public func pushNotifications() {
        profileCoordinator.pushNotifications()
    }
}
