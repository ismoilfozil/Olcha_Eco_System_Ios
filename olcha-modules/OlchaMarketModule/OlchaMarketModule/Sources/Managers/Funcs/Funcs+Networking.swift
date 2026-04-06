//
//  Funcs+Networking.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 18/08/22.
//

import Foundation
extension Funcs {
    
    // TO-DO make this func O(1)
    static func getFeaturesAPI(features: [FeatureData]) -> [URLQueryItem] {
        var queryItems: [URLQueryItem] = []
        var index = 0
        if features.count > 0 {
            var featureApi = ""
            var i = 0
            while i < features.count  {
                var k = 0
                let values = features[i].values
                while k < values?.count ?? 0 {
                    let value = values?[k]
                    if (value?.isSelected ?? false) == true && (value?.isEnabled ?? true) == true {
                        if let feature_id = value?.feature_id {
                            if let id = value?.id {
                                queryItems.append(
                                    .init(name: "features[\(feature_id)][\(index)]",
                                          value: "\(id)"))
                                
                                index += 1
                            }
                        }
                    }
                    k = k + 1
                }
                i = i + 1
            }
            return queryItems
        }
        return []
    }
    
    static func getManufactureresAPI(manufacturers: [Manufacturer]) -> [URLQueryItem] {
        var queryItems: [URLQueryItem] = []
        var i = 0
        for manufacturer in manufacturers {
            if (manufacturer.isEnabled ?? true) == true && (manufacturer.isSelected ?? false) == true {
                if let id = manufacturer.id {
                    queryItems.append(
                        .init(name: "manufacturer[\(i)]", value: "\(id)")
                    )
                    i += 1
                } else if let alias = manufacturer.slug {
                    queryItems.append(
                        .init(name: "manufacturer[\(i)]", value: "\(alias)")
                    )
                    i += 1
                }
            }
            
        }
        
        
        return queryItems
    }
    
    static func getStoresAPI(stores: [Store]) -> [URLQueryItem] {
        var queryItems : [URLQueryItem] = []
        var i = 0
        for store in stores {
            if let id = store.id {
                queryItems.append(.init(name: "store[\(i)]", value: "\(id)"))
                i += 1
            }
        }
        return queryItems
    }
    
    static func getTagsAPI(tags: [TagModel]) -> [URLQueryItem] {
        var queryItems: [URLQueryItem] = []
        var i = 0
        for tag in tags {
            if (tag.isEnabled ?? true) == true && (tag.isSelected ?? false) == true {
                if let slug = tag.slug {
                    queryItems.append(.init(name: "tags[\(i)]", value: slug))
                    i += 1
                }
            }
        }
        
        return queryItems
    }
    
    static func getShippingTypeProducts(productsList: [ [String: Int]]) -> [URLQueryItem] {
        var queryItems: [URLQueryItem] = []
        var i = 0
        for list in productsList {
            for item in list {
                queryItems.append(
                    .init(name: "products[\(i)][\(item.key)]",
                          value: "\(item.value)")
                )
            }
            i += 1
        }
        return queryItems
    }
    
    static func productAlias(from url: String?) -> String? {
        guard let url = url, url.contains("product/view/") else { return nil }
        return url.components(separatedBy: "product/view/").last
    }
}
