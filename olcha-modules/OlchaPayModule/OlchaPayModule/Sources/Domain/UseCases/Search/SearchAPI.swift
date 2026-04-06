//
//  SearchAPI.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 03/04/23.
//

import Foundation
import OlchaCore
public enum SearchAPI {
    case providers(filter: SearchFilter)
}

extension SearchAPI: BaseOlchaPayApi {
    
    public var queryItems: [URLQueryItem] {
        switch self {
        case .providers(let filter):
            var items: [URLQueryItem] = []
            
            if let value = filter.page {
                items.append(.init(name: "page", value: value.string))
            }
            
            if let value = filter.search {
                items.append(.init(name: "search", value: value))
            }
            
            if let value = filter.categoryID {
                items.append(.init(name: "category_id", value: value.string))
            }
            
            return items
        }
    }
    
    
    public var path: String {
        switch self {
        case .providers:
            return "providers/"
        }
    }
    
    public var method: RequestType {
        switch self {
        case .providers:
            return .get
        }
    }
    
    public var body: Data? {
        var data: Data?
        switch self {
            default:
            break
        }
        return data
    }
    
    
}
