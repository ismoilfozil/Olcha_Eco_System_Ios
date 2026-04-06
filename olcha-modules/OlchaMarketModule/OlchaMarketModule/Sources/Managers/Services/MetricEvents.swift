//
//  MetricEvents.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 25/03/23.
//

import UIKit
import OlchaAuth
class MetricEvents {
    static let shared = MetricEvents()
    
    func cartEvent(_ product: ProductModel?, type: CountType) {
        AppMetricaService.shared.cartEvent(product, type: type)
        if type == .plus {
            FacebookService.shared.addToCart(product)
        }
    }
    
    func removeProductFromCartEvent(_ product: ProductModel?, type: UIViewController.Type) {
        AppMetricaService.shared.removeProductFromCartEvent(product, type: type)
    }
    
    func addToCartEvent(_ product: ProductModel?, _ type: UIViewController.Type) {
        AppMetricaService.shared.addToCartEvent(product, type)
        FacebookService.shared.addToCart(product)
    }
    
    func addToFavourites(_ product: ProductModel?) {
        FacebookService.shared.addToFavourites(product)
    }
    
    func openPageEvent(_ product: ProductModel?, _ type: UIViewController.Type) {
        AppMetricaService.shared.openPageEvent(product, type)
        FacebookService.shared.openPageEvent(product)
    }
    
    func beginCheckoutEvent(_ product: ProductModel?,
                            _ discounts: [String],
                            _ orderID: String,
                            _ type: UIViewController.Type
    ) {
        AppMetricaService.shared.beginCheckoutEvent(product, discounts, orderID, type)
    }
    
    func purchaseEvent(_ observers: CartObservers,
                       _ orderFinished: CheckoutOrdered?) {
        AppMetricaService.shared.purchaseEvent(observers, orderFinished)
        FacebookService.shared.purchasedEvent(observers, orderFinished)
    }
    
    func sendUserInfo(_ info: User?) {
        AppMetricaService.shared.sendUserInfo(info)
    }
    
    func customEvent(title: String,
                     messages: [AnyHashable: Any]) {
        AppMetricaService.shared.customEvent(title: title, messages: messages)
    }
}
