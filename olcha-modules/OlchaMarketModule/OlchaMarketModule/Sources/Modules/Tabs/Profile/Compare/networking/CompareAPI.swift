//
//  ComparePageAPI.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 15/08/22.
//

import Foundation
import OlchaCore
enum CompareAPI: OlchaMarketAPI {

    case compareOptions(products: [ProductModel])
    case addCompare(product: ProductModel?)
    case removeCompare(product: ProductModel?)
    case removeCompareFrom(category: CategoryModel?)
    case loadProducts
    case loadCompareProducts(category: CategoryModel?)
    case loadCategories
    
    case mergeCompare
    
}

extension CompareAPI {
    
    var queryItems: [URLQueryItem] {
        switch self {
        case .compareOptions(let products):
            return products
                .map { $0.id }
                .compactMap { URLQueryItem(name: "products[]", value: $0?.string) }
        default:
            return []
        }
    }
    
    var path: String {
        switch self {
        case .compareOptions:
            return "products/compare"
        case .addCompare(let product):
            return "compare/\((product?.id ?? 0).string)"
        case .removeCompare(let product):
            return "compare/\((product?.id ?? 0).string)"
        case .loadProducts:
            return "compare-products"
        case .removeCompareFrom(let category):
            return "compare/delete/\((category?.id ?? 0).string)"
        case .loadCompareProducts(_):
            return ""
        case .loadCategories:
            return ""
        case .mergeCompare:
            return "merge-comparisons"
        }
    }

    var method: RequestType {
        switch self {
        case .removeCompareFrom:
            return .post
        default:
            return .get
        }
    }

    var body: Data? {
        switch self {
        default: return nil
        }
    }

}
