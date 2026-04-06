//
//  FacebookService.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 25/03/23.
//

import Foundation
//import FBSDKCoreKit
//import FacebookCore
public class FacebookService {
    
    private let appID = "165727962956470"
    
    enum EventParametres: String {
        case fb_product_name
        case fb_product_cart_count
        case fb_order_id
    }
    
    
    public static let shared = FacebookService()
    
    private let isFacebookEnabled = true
    
    public init() {
        
    }
    
    public func mainConfiguration() {
//        AppEvents.activateApp()
//        Settings.appID = appID
//        Settings.displayName = "Olcha Bozor"
//        AppEvents.loggingOverrideAppID = appID
    }
    
    func openPageEvent(_ product: ProductModel?) {
        guard isFacebookEnabled else { return }
        
//        AppEvents.logEvent(
//            AppEvents.Name.viewedContent,
//            valueToSum: product?.total_price?.double ?? 0.0,
//            parameters: getParametredProduct(product)
//        )
    }
    
    func addToFavourites(_ product: ProductModel?) {
        guard isFacebookEnabled else { return }
        
//
//        AppEvents.logEvent(
//            AppEvents.Name.addedToWishlist,
//            valueToSum: product?.total_price?.double ?? 0.0,
//            parameters: getParametredProduct(product)
//        )
    }
    
    func addToCart(_ product: ProductModel?) {
        guard isFacebookEnabled else { return }
//        AppEvents.logEvent(
//            AppEvents.Name.addedToCart,
//            valueToSum: product?.total_price?.double ?? 0.0,
//            parameters: getParametredProduct(product)
//        )
    }
    
    func purchasedEvent(_ observers: CartObservers,
                        _ orderFinished: CheckoutOrdered?) {
        guard isFacebookEnabled else { return }
//        AppEvents.logEvent(.purchased,
//                           parameters: getOrderParametredProducts(
//                            observers.products, orderID:
//                                orderFinished?.order_id)
//        )
    }
    
    private func getParametredProduct(_ product: ProductModel?) -> [String: Any] {
        return [:
//            EventParametres.fb_product_cart_count.rawValue: product?.cart_count,
//            EventParametres.fb_product_name.rawValue: product?.getName(),
//            AppEvents.ParameterName.contentID.rawValue: product?.id,
//            AppEvents.ParameterName.contentType.rawValue: product?.category?.alias,
//            AppEvents.ParameterName.currency.rawValue: "uzs"
        ]
    }
    
    private func getOrderParametredProducts(_ products: [ProductModel?], orderID: Int?) -> [String: Any] {
        let forcedProducts = products.compactMap { $0 }
        return [:
//            EventParametres.fb_order_id.rawValue: orderID,
//            EventParametres.fb_product_cart_count.rawValue: forcedProducts.map { $0.cart_count },
//            EventParametres.fb_product_name.rawValue: forcedProducts.map { $0.getName() },
//            AppEvents.ParameterName.contentID.rawValue: forcedProducts.map { $0.id },
//            AppEvents.ParameterName.contentType.rawValue: forcedProducts.map { $0.category?.alias },
//            AppEvents.ParameterName.currency.rawValue: "uzs"
        ]
    }
}
