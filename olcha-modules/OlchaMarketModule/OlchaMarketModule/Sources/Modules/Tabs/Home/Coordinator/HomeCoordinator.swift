//
//  HomeCoordinator.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 30/06/22.
//
import UIKit
import OlchaUI
public protocol HomeCoordinatorProtocol: Coordinator {
    func pushProductPage(with product: ProductModel?)
    func pushProductsList(with filters: ProductListFilters)
    func pushDifferentCategoriesList(route: String)
    func pushCatalogListPage(pageState: DetailedCatalogListPage.InitialPageState)
    func pushSlider(_ slider: Slider?)
    func pushBrandProducts(filters: ProductListFilters)
    func pushAllBrands()
    func pushAllNews()
    func pushBlog(blog: Blog?)
    
    func pushSearch()
    func pushWebPage(urlString: String)
    
    func pushNotificationPage()
    func pushOrder(order: Order?)
    func pushFavourites()
    
    func pushOrderPay(urlString: String)
    
    func presentCartVariation(product: ProductModel?,
                              productType: ProductType)
}
public class HomeCoordinator: OlchaMainCoordinator, HomeCoordinatorProtocol {
    
    public override func start() {
        let vc = HomePage()
        vc.coordinator = self
        navigationController.set([vc])
    }
    
    public func pushProductPage(with product: ProductModel?) {
        productCoordinator.pushProductPage(product: product)
    }
    
    public func pushProductsList(with filters: ProductListFilters) {
        catalogCoordinator.pushProductsList(filters: filters)
    }
    
    public func pushDifferentCategoriesList(route: String) {
        catalogCoordinator.pushDifferentCategoriesList(route: route)
    }
    
    public func pushCatalogListPage(pageState: DetailedCatalogListPage.InitialPageState) {
        catalogCoordinator.pushCatalogListPage(pageState: pageState)
    }
    
    public func pushSlider(_ slider: Slider?) {
        sliderCoordinator.pushSlider(slider)
    }

    public func pushAllBrands() {
        brandsCoordinator.start()
    }
    
    public func pushBrandProducts(filters: ProductListFilters) {
        brandsCoordinator.pushBrandProducts(filters: filters)
    }
    
    public func pushAllNews() {
        let vc = NewsListPage()
        vc.coordinator = self
        navigationController.push(vc)
    }
    
    public func pushBlog(blog: Blog?) {
        let vc = NewsPage()
        vc.blog = blog
        navigationController.push(vc)
    }
    
    public func pushSearch() {
        searchCoordinator.start()
    }
    
    public func pushNotificationPage() {
        profileCoordinator.pushNotifications()
    }
    
    public func pushOrderPay(urlString: String) {
        profileCoordinator.pushOrderPay(urlString: urlString)
    }
    
    public func pushOrder(order: Order?) {
        profileCoordinator.pushOrder(order: order)
    }
    
    public func pushFavourites() {
        profileCoordinator.pushFavourites(animated: true)
    }
    
    public func presentCartVariation(product: ProductModel?,
                                     productType: ProductType) {
        cartCoordinator.presentCartVariation(product: product,
                                             productType: productType)
    }
    
    public func pushWebPage(urlString: String) {
        let vc = WebPage()
        vc.urlString = urlString
        navigationController.push(vc)
    }
}
