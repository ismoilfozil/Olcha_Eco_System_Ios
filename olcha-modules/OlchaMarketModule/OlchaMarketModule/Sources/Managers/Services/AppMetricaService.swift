//
//  AppmetricaService.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 27/06/22.
//

import Foundation
import YandexMobileMetrica
import UIKit

import OlchaAuth
public class AppMetricaService {
    
    private var metricaIsEnabled: Bool {
        return AuthGlobalDefaults.user.id != 146562
    }
    
    public static let shared = AppMetricaService()
    
    public let ApiKey = "257b63e4-59cc-4fba-ae44-366d0314e7b0"
    
    private let payload = ["configuration": "portrait",
                           "full_screen": "true"]
    
    private lazy var reporter = YMMYandexMetrica.reporter(forApiKey: ApiKey)
    
    func cartEvent(_ product: ProductModel?, type: CountType) {
        if type == .plus {
            addToCartEvent(product, ProductPage.self)
        } else {
            removeProductFromCartEvent(product, type: ProductPage.self)
        }
    }
    
    func removeProductFromCartEvent(_ product: ProductModel?, type: UIViewController.Type) {
        guard metricaIsEnabled else { return }
        let screen = getScreen(with: String(describing: type) )


        let product = getMetricProduct(product)
        guard let actualPrice = product.actualPrice else { return }
        let cartItem = getMetricCartItem(product: product,
                                         screen: screen,
                                         actualPrice: actualPrice)


        self.reporter?.report(eCommerce: YMMECommerce.removeCartItemEvent(cartItem: cartItem), onFailure: nil)
    }
    
    func addToCartEvent(_ product: ProductModel?, _ type: UIViewController.Type) {
        guard metricaIsEnabled else { return }
        let product = getMetricProduct(product)
        let screen = getScreen(with: String(describing: type))
        guard let actualPrice = product.actualPrice else { return }
        let cartItem = getMetricCartItem(product: product,
                                         screen: screen,
                                         actualPrice: actualPrice)
        self.reporter?.report(eCommerce: YMMECommerce.addCartItemEvent(cartItem: cartItem), onFailure: nil)
    }
    
    func openPageEvent(_ product: ProductModel?, _ type: UIViewController.Type) {
        guard metricaIsEnabled else { return }
        let product = getMetricProduct(product)
        let screen = getScreen(with: String(describing: type))
        self.reporter?
            .report(eCommerce:
                        YMMECommerce.showProductCardEvent(product: product,
                                                          screen: screen),
                    onFailure: nil)
    }
    
    func beginCheckoutEvent(_ product: ProductModel?,
                            _ discounts: [String],
                            _ orderID: String,
                            _ type: UIViewController.Type
    ) {
        guard metricaIsEnabled else { return }
        let product = getMetricProduct(product, discounts)
        let screen = getScreen(with: String(describing: type))
        guard let actualPrice = product.actualPrice else { return }

        let cartItem = getMetricCartItem(product: product, screen: screen, actualPrice: actualPrice)

        let order = getMetricOrder(orderID: orderID, cartItem: cartItem)
        self.reporter?.report(eCommerce: YMMECommerce.beginCheckoutEvent(order: order), onFailure: nil)
    }
    
    func purchaseEvent(_ observers: CartObservers,
                       _ orderFinished: CheckoutOrdered?) {
        guard metricaIsEnabled else { return }
        for product in observers.products {
#warning("CART!!!!!!!!!!!!!!")
//            let product = getMetricProduct(product, [observers.couponString].compactMap { $0 })
//            let screen = getScreen(with: String(describing: CartPage.self))
//            if let actualPrice = product.actualPrice {
//                let cartItem = getMetricCartItem(product: product, screen: screen, actualPrice: actualPrice)
//                if let id = orderFinished?.order_id?.string {
//                    let order = getMetricOrder(orderID: id, cartItem: cartItem)
//
//                    self.reporter?.report(eCommerce: YMMECommerce.purchaseEvent(order: order), onFailure: nil)
//                }
//            }
        }
    }
    
    func sendUserInfo(_ info: User?) {
        
        let userProfile = YMMMutableUserProfile()
        var year: UInt = 0
        var month: UInt = 0
        var day: UInt = 0
        
        if let birthdate = info?.birthdate {
            let arr = birthdate.split(separator: "-")
            if arr.count == 3 {
                year = UInt(arr[0]) ?? 0
                month = UInt(arr[1]) ?? 0
                day = UInt(arr[2]) ?? 0
            }
        }
        
        userProfile.apply(from: [
            YMMProfileAttribute.name().withValue(info?.name ?? ""),
            YMMProfileAttribute.gender().withValue( ((info?.gender ?? 1) == 1) ? .male : .female),
            YMMProfileAttribute.birthDate().withDate(year: year, month: month, day: day)
        ])


        self.reporter?.setUserProfileID("\(info?.id ?? -1)")
        
        self.reporter?.report(userProfile, onFailure: nil)
    }
    
    func customEvent(title: String,
                     messages: [AnyHashable: Any]) {
        reporter?.reportEvent(title,
                              parameters: messages,
                              onFailure: nil)
    }
    
}

private extension AppMetricaService {
    func getScreen(with name: String) -> YMMECommerceScreen {
        return YMMECommerceScreen(name: name, categoryComponents: nil, searchQuery: nil, payload: payload)
    }

    func getMetricCartItem(product: YMMECommerceProduct,
                           screen: YMMECommerceScreen,
                           actualPrice: YMMECommercePrice
    ) -> YMMECommerceCartItem {
        let referrer = YMMECommerceReferrer(type: nil, identifier: nil, screen: screen)

        let cartItem = YMMECommerceCartItem(product: product,
                                            quantity: .one,
                                            revenue: actualPrice,
                                            referrer: referrer)
        return cartItem
    }

    func getMetricProduct(_ product: ProductModel?, _ discounts: [String] = []) -> YMMECommerceProduct {
        let actualAmount = YMMECommerceAmount(unit: "UZS",
                                              value: .init(string: product?.total_price ?? "0.0"))
        let actualPrice = YMMECommercePrice(
            fiat: actualAmount)

        let originalAmount = YMMECommerceAmount(unit: "UZS",
                                                value: .init(string: product?.total_price ?? "0.0"))
        let originalPrice = YMMECommercePrice(
            fiat: originalAmount)

        let name: String = .lang(product?.name_ru, product?.name_uz, product?.name_oz)

        var categoryComponents = [String]()
        let categoryName: String = .lang( product?.category?.name_ru,  product?.category?.name_uz,  product?.category?.name_oz)
        categoryComponents.append(categoryName)


        var manufactureName: String?
        if let manufacture = product?.manufacturer {
            manufactureName = .lang( manufacture.name_ru,  manufacture.name_uz,  manufacture.name_oz)
            categoryComponents.append(manufactureName ?? "")
        }

        let product = YMMECommerceProduct(sku: "\(product?.id ?? -1)",
                                               name: name,
                                               categoryComponents: categoryComponents,
                                               payload: payload,
                                               actualPrice: actualPrice,
                                               originalPrice: originalPrice,
                                               promoCodes: discounts)

        return product
    }


    func getMetricOrder(orderID: String, cartItem: YMMECommerceCartItem) -> YMMECommerceOrder {
        return YMMECommerceOrder(identifier: orderID, cartItems: [cartItem], payload: payload)
    }
}
