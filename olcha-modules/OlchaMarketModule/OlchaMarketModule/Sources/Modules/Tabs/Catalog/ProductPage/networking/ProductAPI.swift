//
//  ProductAPI.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 18/07/22.
//

import Foundation
import OlchaCore
enum ProductAPI: OlchaMarketAPI {
    case variations(productID: Int)
    case storeVariations(productID: Int, storeID: Int)
    case productsID(id: Int)
    case productsAlias(alias: String)
    case characteristics(id: Int)
    case priceHistory(id: Int)
}

extension ProductAPI {
    var queryItems: [URLQueryItem] {
        switch self {
        case .productsID(let id):
            return [
                .init(name: "id", value: "\(id)")
            ]
        case .productsAlias(let alias):
            return [
                .init(name: "alias", value: alias)
            ]
        case .characteristics(let id):
            return [
                .init(name: "product_id", value: "\(id)")
            ]
        default:
            return []
        }
    }
    
    var path: String {
        switch self {
        case .variations(let productID):
            return "product/variations-new/\(productID)"
        case .storeVariations(let productID, let storeID):
            return "store-product/variations-new/\(productID)/\(storeID)"
        case .productsID:
            return "products/view"
        case .productsAlias:
            return "products/view"
        case .characteristics:
            return "product/features"
        case .priceHistory(let id):
            return "products/\(id)/price-history"
        }
    }
    
    var method: RequestType {
        switch self {
        default: return .get
        }
        
    }
    
    var body: Data? {
        var data: Data?
        return data
    }
}
