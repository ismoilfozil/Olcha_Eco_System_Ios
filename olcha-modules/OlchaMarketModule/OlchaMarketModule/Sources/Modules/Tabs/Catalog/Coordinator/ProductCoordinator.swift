//
//  ProductCoordinator.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 15/07/22.
//

import Combine
import UIKit
import OlchaUI

public protocol ProductCoordinatorProtocol: Coordinator {
    func pushProductPage(product: ProductModel?, animated: Bool)
    func pushProductsList(filters: ProductListFilters, animated: Bool)
    func presentGiftInfo(product: ProductModel?)
    func presentAllRatings(viewModel: ReviewsPageViewModel)
    func presentAddBasket(product: ProductModel?, viewModel: CatalogPageViewModel?)
    func presentSimpleBuy(product: ProductModel?, type: SimpleBuyModalPage.BuyType)
    func presentCreditBuy(product: ProductModel?)
    func pushStoreProducts(product: ProductModel?)
    
    func pushAddReview(product: ProductModel?)
    func pushEditReview(review: Comment)
    func pushReviewMedia(product: ProductModel?, reviewsData: ReviewFilesData?, index: Int)
    func pushReviewMedia(review: Comment?, index: Int)
    func pushAskQuestion(product: ProductModel?)
    func pushAllFAQs(product: ProductModel?)
    
    func pushReviewReplies(review: Comment?, product: ProductModel?)
    func pushFAQReplies(question: Comment?, product: ProductModel?)
    
    func pushAllReviews(product: ProductModel?)
    
    
    func pushCompare(product: ProductModel?)
    func pushFavourites()
    func pushAllBrands()
    func pushBrandProducts(filters: ProductListFilters)
    
    func pushCatalogListPage(pageState: DetailedCatalogListPage.InitialPageState)
    func pushCreditBuy(data: CreditOrder)
    
    func pushMedia(images: [String], index: Int)
    
    func presentCartVariation(product: ProductModel?,
                              productType: ProductType)
    
    func presentOpenProductVariation(product: ProductModel?,
                                     productType: ProductType,
                                     completion: ((ProductModel?) -> Void)?)
    
    func changeCartTab()
    
    func presentFeaturesFilterModal(with filters: ProductListFilters?, index: Int)
    func presentPriceFilterModal(with filters: ProductListFilters?)
    func presentManufacturersFilterModal(with filters: ProductListFilters?)
    func presentCategoryListFilterModal(filters: ProductListFilters?)
    func presentCategoryListForManufacturer(filters: ProductListFilters?)
    func pushFeaturesPage(filters: ProductListFilters?)
    
    func presentPriceHistory(history: [PriceHistory])
    
    func presentCartVerification(verificationFinished: (() -> Void)?)
    
    func pushAuth(completion: (() -> Void)?)
    func presentProductDescription(product: ProductModel?)
    func presentProductCharacteristics(data: CharacteristicsData?)
}

public extension ProductCoordinatorProtocol {
    func pushProductPage(product: ProductModel?, animated: Bool = true) {
        dismissPresentedViewController()
        let vc = ProductPage()
        vc.product = product
        vc.coordinator = self
        navigationController.push(vc, animated: animated)
    }

    func pushProductsList(filters: ProductListFilters, animated: Bool = true) {
        let vc = ProductsListPage()
        vc.filters = filters
        vc.coordinator = self
        navigationController.push(vc, animated: animated)
    }
}

public class ProductCoordinator: OlchaMainCoordinator, ProductCoordinatorProtocol {
    private var dismissedViewController: UIViewController?
    
    public override func start() {}
    
    public func presentGiftInfo(product: ProductModel?) {
        let vc = GiftInfoModalPage()
        navigationController.presentModally(vc)
    }
    
    public func presentAllRatings(viewModel: ReviewsPageViewModel) {
        let vc = AllRatingsModalPage()
        vc.viewModel = viewModel
        navigationController.presentModally(vc)
    }
    
    public func presentSimpleBuy(product: ProductModel?, type: SimpleBuyModalPage.BuyType) {
        dismissPresentedViewController()
        let vc = SimpleBuyModalPage()
        vc.product = product
        vc.type = type
        navigationController.presentModally(vc)
    }
    
    public func presentAddBasket(product: ProductModel?, viewModel: CatalogPageViewModel?) {
        let vc = AddBasketModalPage()
        vc.coordinator = self
        vc.product = product
        vc.catalogViewModel = viewModel
        navigationController.presentModally(vc)
    }
    
    public func presentCreditBuy(product: ProductModel?) {
        
        let vc = CreditBuyModalPage()
        vc.coordinator = self
        vc.product = product
        navigationController.presentModally(vc)
        
    }
    
    public func pushStoreProducts(product: ProductModel?) {
        let vc = StoreProductsPage()
        vc.coordinator = self
        vc.product = product
        navigationController.push(vc)
    }
    
    public func pushReviewMedia(product: ProductModel?, reviewsData: ReviewFilesData?, index: Int) {
        reviewCoordinator.pushReviewMedia(product: product, reviewsData: reviewsData, index: index)
    }
    
    public func pushReviewMedia(review: Comment?, index: Int) {
        reviewCoordinator.pushReviewMedia(review: review, index: index)
    }
    
    public func pushAddReview(product: ProductModel?) {
        reviewCoordinator.pushAddReview(product: product)
    }
    
    public func pushEditReview(review: Comment) {
        reviewCoordinator.pushEditReview(review: review)
    }
    
    public func pushAskQuestion(product: ProductModel?) {
        reviewCoordinator.pushAskQuestion(product: product)
    }
    
    public func pushAllFAQs(product: ProductModel?) {
        reviewCoordinator.pushAllFAQs(product: product)
    }
    
    public func pushReviewReplies(review: Comment?, product: ProductModel?) {
        reviewCoordinator.pushReviewReplies(review: review, product: product)
    }
    
    public func pushFAQReplies(question: Comment?, product: ProductModel?) {
        reviewCoordinator.pushFAQReplies(question: question, product: product)
    }
    
    public func pushAllReviews(product: ProductModel?) {
        reviewCoordinator.pushAllReviews(product: product)
    }
    
    public func pushCompare(product: ProductModel?) {
        profileCoordinator.pushCompare(product: product)
    }
    
    public func pushFavourites() {
        profileCoordinator.pushFavourites(animated: true)
    }
    
    public func pushAllBrands() {
        brandsCoordinator.start()
    }
    
    public func pushBrandProducts(filters: ProductListFilters) {
        brandsCoordinator.pushBrandProducts(filters: filters)
    }
    
    public func pushCatalogListPage(pageState: DetailedCatalogListPage.InitialPageState) {
        catalogCoordinator.pushCatalogListPage(pageState: pageState)
    }
    
    public func pushCreditBuy(data: CreditOrder) {
        cartCoordinator.pushCreditCartPage(data: data)
    }
    
    public func pushMedia(images: [String], index: Int) {
        let vc = ReviewMediaPage()
        vc.files = images.map { Funcs.getFile($0) }
        vc.currentFile = index
        navigationController.push(vc)
    }
    
    public func presentCartVariation(product: ProductModel?,
                                     productType: ProductType) {
        cartCoordinator.presentCartVariation(product: product, productType: productType)
    }
    
    
    public func presentOpenProductVariation(product: ProductModel?,
                                     productType: ProductType,
                                     completion: ((ProductModel?) -> Void)?) {
        cartCoordinator.presentOpenProductVariation(product: product,
                                                    productType: productType,
                                                    completion: completion)
    }
    
    public func changeCartTab() {
        cartCoordinator.changeCartTab()
    }
    
    public func presentFeaturesFilterModal(with filters: ProductListFilters?, index: Int) {
        featureCoordinator.presentFeaturesFilterModal(with: filters, index: index)
    }
    
    public func presentPriceFilterModal(with filters: ProductListFilters?) {
        featureCoordinator.presentPriceFilterModal(with: filters)
    }
    
    public func presentManufacturersFilterModal(with filters: ProductListFilters?) {
        featureCoordinator.presentManufacturersFilterModal(with: filters)
    }
    
    public func presentCategoryListFilterModal(filters: ProductListFilters?) {
        catalogCoordinator.presentCategoryListFilterModal(filters: filters)
    }
    
    public func presentCategoryListForManufacturer(filters: ProductListFilters?) {
        catalogCoordinator.presentCategoryListForManufacturer(filters: filters)
    }
    
    public func pushFeaturesPage(filters: ProductListFilters?) {
        featureCoordinator.pushFeaturesPage(with: filters)
    }
    
    public func presentPriceHistory(history: [PriceHistory]) {
        let vc = PriceHistoryModalPage()
        vc.priceHistory = history
        navigationController.presentModally(vc)
    }
    
    public func presentCartVerification(verificationFinished: (() -> Void)?) {
        dismissPresentedViewController()
        verificationCoordinator.presentCartVerification(verificationFinished: verificationFinished)
    }
    
    public func dismissViewController() {
        navigationController.presentedViewController?.dismiss(animated: true, completion: nil)
    }
    
    public func dismissPresentedViewController() {
        if navigationController.presentedViewController is ModalPageType {
            self.dismissedViewController = navigationController.presentedViewController
            dismissViewController()
        }
    }
    
    public func presentHistoricalDismissedViewController() {
        
        if let vc = self.dismissedViewController {
            navigationController.presentModally(vc)
            self.dismissedViewController = nil
        }
    }
    
    public func pushAuth(completion: (() -> Void)?) {
        authCoordinator.pushAuth(isSet: false, completion: completion)
    }
    
    public func presentProductDescription(product: ProductModel?) {
        let vc = ProductDescriptionsModalPage()
        vc.setup(product: product)
        navigationController.presentModally(vc)
    }
    
    public func presentProductCharacteristics(data: CharacteristicsData?) {
        let vc = ProductCharacteristicsModalPage()
        vc.setup(with: data)
        navigationController.presentModally(vc)
    }
}
