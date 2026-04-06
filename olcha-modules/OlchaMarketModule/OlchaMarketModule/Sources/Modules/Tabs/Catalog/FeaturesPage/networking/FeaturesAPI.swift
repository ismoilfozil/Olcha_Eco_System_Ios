//
//  FeaturesPageAPI.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 18/08/22.
//

import Foundation
import OlchaCore
enum FeaturesAPI: OlchaMarketAPI {
    
    case features(categoryAlias: String)
    case filterFeatures(categoryAlias: String, filters: ProductListFilters)
    case filterManufacturers(filters: ProductListFilters)
    case tags(categoryAlias: String)
}

extension FeaturesAPI {
    //query check
    var queryItems: [URLQueryItem] {
        switch self {
        case .filterFeatures(_, let filters):
            var queryItems: [URLQueryItem] = []
            queryItems.append(.init(name: "page", value: "1"))
            
            queryItems.append(
                contentsOf: Funcs.getFeaturesAPI(features: filters.features)
            )
            
            queryItems.append(
                contentsOf: Funcs.getManufactureresAPI(manufacturers: filters.manufacturers)
            )
            
            queryItems.append(
                contentsOf: Funcs.getTagsAPI(tags: filters.tags)
            )
            
            return queryItems
        case .filterManufacturers(let filters):
            var queryItems: [URLQueryItem] = []
            queryItems.append(.init(name: "page", value: "1"))
            queryItems.append(
                contentsOf: Funcs.getFeaturesAPI(features: filters.features)
            )
            
            queryItems.append(
                contentsOf: Funcs.getTagsAPI(tags: filters.tags)
            )
            
            return queryItems
        case .tags(let categoryAlias):
            return [
                .init(name: "category", value: categoryAlias)
            ]
            
        default: return []
        }
    }
    
    var path: String {
        switch self {
        case .features(let categoryAlias):
            return "categories/\(categoryAlias)/features"
        case .filterFeatures(let categoryAlias, _):
            return "categories/\(categoryAlias)/features/filter"
        case .filterManufacturers(_):
            return "manufacturer/filter"
        case .tags(_):
            return "products/tags"
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
