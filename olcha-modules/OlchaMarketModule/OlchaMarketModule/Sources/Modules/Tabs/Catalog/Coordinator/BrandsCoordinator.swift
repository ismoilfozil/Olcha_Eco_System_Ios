//
//  BrandsCoordinator.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 31/08/22.
//

import OlchaUI
import UIKit
public protocol BrandsCoordinatorProtocol: Coordinator {
    
 
    func pushProductsList(filters: ProductListFilters)
    func pushProductPage(product: ProductModel?)
    func pushCatalogListPage(pageState: DetailedCatalogListPage.InitialPageState)
    func pushLetterBrands(letter: String)
    
    func pushBrandProducts(filters: ProductListFilters)
    func pushSlider(_ slider: Slider?)
    func presentCartVariation(product: ProductModel?,
                              productType: ProductType)
}

public class BrandsCoordinator: OlchaMainCoordinator, BrandsCoordinatorProtocol {
    
    public override func start() {
        let vc = AllBrandsPage()
        vc.coordinator = self
        navigationController.push(vc)
    }
    
    public func pushProductsList(filters: ProductListFilters) {
        productCoordinator.pushProductsList(filters: filters)
    }
    
    public func pushCatalogListPage(pageState: DetailedCatalogListPage.InitialPageState) {
        catalogCoordinator.pushCatalogListPage(pageState: pageState)
    }
    
    public func pushLetterBrands(letter: String) {
        let vc = LetterAllBrandsPage()
        vc.coordinator = self
        vc.letter = letter
        navigationController.push(vc)
    }
    
    public func pushBrandProducts(filters: ProductListFilters) {
        let vc = BrandProductsPage()
        vc.coordinator = productCoordinator
        vc.brandCoordinator = self
        vc.filters = filters
        navigationController.push(vc)
    }
    
    public func pushProductPage(product: ProductModel?) {
        productCoordinator.pushProductPage(product: product)
    }
    
    public func pushSlider(_ slider: Slider?) {
        sliderCoordinator.pushSlider(slider)
    }
    
    public func presentCartVariation(product: ProductModel?,
                                     productType: ProductType) {
        cartCoordinator.presentCartVariation(product: product,
                                             productType: productType)
    }
    
}
