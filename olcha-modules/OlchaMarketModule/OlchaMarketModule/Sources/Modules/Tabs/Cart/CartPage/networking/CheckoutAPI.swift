//
//  CheckoutAPI.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 28/07/22.
//

import Foundation
import OlchaCore
import OlchaUtils
enum CheckoutAPI: OlchaMarketAPI {
    case simpleBuy(model: SimpleBuyRequest)
    case storesProducts(model: StoresProductsRequest)
    case shippingTypes(districtID: Int, products: [  [String: Int]  ])
    case paymentTypes(regionID: Int, withoutBalance: Bool)
    case getCost(model: GetCostRequest)
    case checkCoupon(model: CouponRequest)
    case bonus
    case order(model: GetCostRequest)
    case loadPaymentsBalance(url: String)
    case bonusRule
}

extension CheckoutAPI {
    
    var baseURL: String {
        switch self {
        case .loadPaymentsBalance(let url):
            return url
        default:
            return Texts.url.olcha.base
        }
    }
    
    var version: String {
        switch self {
        case .loadPaymentsBalance:
            return ""
        case .storesProducts, .order:
            return Texts.url.getVersion(3)
        case .getCost:
            return Texts.url.getVersion(3)
        case .bonusRule:
            return Texts.url.getVersion(3)
        default:
            return Texts.url.getVersion(2)
        }
    }
    
    var queryItems: [URLQueryItem] {
        
        switch self {
        case .shippingTypes(_ , let products):
            return Funcs.getShippingTypeProducts(productsList: products)
        case .paymentTypes(_, let withoutBalance):
            
            if !withoutBalance {
                return [
                    .init(name: "type", value: "true")
                ]
            } else {
                return []
            }
        default: return []
        }
    }
    
    
    var path: String {
        switch self {
        case .simpleBuy:
            return "call-to-order"
        case .storesProducts:
            return "stores-products"
        case .shippingTypes(let districtID, _):
            return "checkout/deliveries/\(districtID)"
        case .paymentTypes(let regionID, _):
            return "checkout/payment-types/\(regionID)"
        case .getCost:
            return "checkout/get-cost"
        case .checkCoupon:
            return "order/coupon"
        case .bonus:
            return "user/bonus"
        case .order:
            return "order/checkout"
        case .loadPaymentsBalance:
            return ""
        case .bonusRule:
            return "bonusRule"
        }
    }
    
    var method: RequestType {
        switch self {
        case .simpleBuy:
            return .post
        case .storesProducts:
            return .post
        case .shippingTypes:
            return .get
        case .paymentTypes:
            return .get
        case .getCost:
            return .post
        case .checkCoupon:
            return .post
        case .bonus:
            return .get
        case .order:
            return .post
        case .loadPaymentsBalance:
            return .get
        case .bonusRule:
            return .get
        }
    }
    
    var body: Data? {
        var data: Data?
        switch self {
        case .simpleBuy(let model):
            do {
                data = try JSONEncoder().encode(model)
            } catch {}
            break
        case .storesProducts(let model):
            do {
                data = try JSONEncoder().encode(model)
            } catch {}
            break
        case .getCost(let model):
            do {
                data = try JSONEncoder().encode(model)
            } catch {}
            break
        case .checkCoupon(let model):
            do {
                data = try JSONEncoder().encode(model)
            } catch {}
            break
        case .order(let model):
            do {
                
                data = try JSONEncoder().encode(model)
                
            } catch {}
            break
        default: break
        }
        
        return data
    }
}
