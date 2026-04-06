//
//  CatalogPageAPI.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 05/07/22.
//

import Foundation
import OlchaCore
enum CatalogAPI: OlchaMarketAPI {

    case searchCategories(search: String)
    case categoriesWithManufacturer(manufacturer: String)
    case categories
    case categoryProducts(filters: ProductListFilters)
    case sliders(alias: String)
    case brands
    case category(alias: String)
    case brand(alias: String)
    case dailyProducts
}

extension CatalogAPI {
    var queryItems: [URLQueryItem] {
        switch self {
        case .searchCategories(let search):
            let queryItems: [URLQueryItem] = [.init(name: "q", value: search)]
            return queryItems
        case .categoryProducts(let filters):
            var queryItems: [URLQueryItem] = [
                .init(name: "page", value: "\(filters.paging.current)"),
                .init(name: "per_page", value: "\(filters.paging.per_page)"),
            ]
            
            if filters.selectedSort != .none {
                queryItems.append(.init(name: "sort_by", value: "\(filters.selectedSort.key)"))
            }
            
            if filters.productsType != ProductsType.none {
                queryItems.append(.init(name: filters.productsType.type, value: "true"))
            }
            
            if let categoryID = filters.category?.id, categoryID > 0 {
                queryItems.append(.init(name: "category", value: "\(categoryID)"))
            } else if let alias = filters.category?.alias, alias != "" {
                queryItems.append(.init(name: "category", value: alias))
            }
            
            if let min = filters.filterPrice.min {
                queryItems.append(.init(name: "price_min", value: "\(min)"))
            }
            
            if let max = filters.filterPrice.max {
                queryItems.append(.init(name: "price_max", value: "\(max)"))
            }
            
            queryItems.append(
                contentsOf: Funcs.getStoresAPI(stores: filters.stores)
            )
            
            queryItems.append(
                contentsOf: Funcs.getFeaturesAPI(features: filters.features)
            )
            
            queryItems.append(
                contentsOf: Funcs.getManufactureresAPI(manufacturers: filters.manufacturers)
            )
            
            queryItems.append(
                contentsOf: Funcs.getTagsAPI(tags: filters.tags)
            )
            
            if filters.search != "" {
                queryItems.append(.init(name: "q", value: filters.search))
            }
            
            if filters.queryRoute != "" {
                queryItems.append(.init(name: "route", value: filters.queryRoute))
            }
            
            return queryItems
        default: return []
        }
    }
    
    var path: String {
        switch self {
        case .categories:
            return "parent-categories"
        case .searchCategories:
            return "products/categories"
        case .categoriesWithManufacturer(let manufacturer):
            return "manufacturers/\(manufacturer)/categories"
        case .categoryProducts(let filters):
            
            var api = "products"
            if filters.similarity != .none,
               filters.alias != "" {
                api += "/\(filters.similarity.rawValue)/\(filters.alias)"
            }
            
            if let id = filters.discountID {
                api = "discounts/\(id)"
            }
            
            if filters.route != "" {
                if filters.route.first == "/" {
                    api = String(filters.route.dropFirst())
                } else {
                    api = String(filters.route)
                }
            }
            
            return api
        case .sliders(let alias):
            return "categories/\(alias)/sliders"
        case .brands:
            return "manufacturers-with-categories"
        case .category(let alias):
            return "category/\(alias)"
        case .brand(let alias):
            return "manufacturer/\(alias)"
        case .dailyProducts:
            return "product-of-the-day"
        }
    }
    
    var method: RequestType {
        switch self {
        default: return .get
        }
    }
    
    var body: Data? {
        return nil
    }

}
