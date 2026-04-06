//
//  SearchAPI.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 28/10/22.
//

import Foundation
import OlchaCore
enum SearchAPI {
    case brands(model: SearchRequest)
    case categories(model: SearchRequest)
    case products(model: SearchRequest)
}

extension SearchAPI: OlchaMarketAPI {
    var path: String {
        switch self {
        case .brands:
            return "search/brands"
        case .categories:
            return "search/categories"
        case .products:
            return "search/products"
        }
    }
    
    var method: RequestType {
        switch self {
        case .brands:
            return .post
        case .categories:
            return .post
        case .products:
            return .post
        }
    }
    
    var body: Data? {
        var data: Data?
        
        switch self {
        case .brands(let model):
            do {
                data = try JSONEncoder().encode(model)
            } catch {}
            break
        case .categories(let model):
            do {
                data = try JSONEncoder().encode(model)
            } catch {}
            break
        case .products(let model):
            do {
                data = try JSONEncoder().encode(model)
            } catch {}
            break
        }
        
        return data
    }
    
    
}
