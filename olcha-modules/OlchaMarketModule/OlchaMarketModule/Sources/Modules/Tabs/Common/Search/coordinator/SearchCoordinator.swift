//
//  SearchCoordinator.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 31/10/22.
//

import UIKit
import OlchaUI
public protocol SearchCoordinatorProtocol: Coordinator {
    func pushProduct(product: ProductModel?)
    func pushProductList(category: CategoryModel?)
    func pushProductList(search: String)
    func pushBrandProducts(filters: ProductListFilters)
    func pushSearchPage(query: String)
}

public class SearchCoordinator: OlchaMainCoordinator, SearchCoordinatorProtocol {
    
    public override func start() {
        let vc = SearchPage()
        vc.coordinator = self
        navigationController.push(vc)
    }
    
    public func pushProduct(product: ProductModel?) {
        productCoordinator.pushProductPage(product: product)
    }
    
    public func pushProductList(category: CategoryModel?) {
        let filters = ProductListFilters()
        filters.category = category
        catalogCoordinator.pushProductsList(filters: filters)
    }
    
    public func pushBrandProducts(filters: ProductListFilters) {
        brandsCoordinator.pushBrandProducts(filters: filters)
    }
 
    public func pushSearchPage(query: String) {
        let vc = SearchPage()
        vc.forcedSearchQuery = query
        navigationController.push(vc)
    }
    
    public func pushProductList(search: String) {
        let filters = ProductListFilters()
        filters.search = search
        catalogCoordinator.pushProductsList(filters: filters)
    }
}
