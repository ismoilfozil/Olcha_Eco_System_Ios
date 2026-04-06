//
//  HomePageNetworking.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 04/07/22.
//

import Foundation
import OlchaUtils
import OlchaCore
enum HomeAPI: OlchaMarketAPI {
    case mainBanner
    case discounts
    case blogs(page: Int)
    case blog(id: Int)
    case builder
    case html(url: String)
    case products
}

extension HomeAPI {
    
    var queryItems: [URLQueryItem] {
        switch self {
        case .blogs(let page):
            return [
                .init(name: "page", value: "\(page)")
            ]
        case .builder:
            return [
                .init(name: "application", value: "android"),
                .init(name: "lang", value: String.getAppLanguage())
            ]
        default: return []
        }
    }
    
    var path: String {
        switch self {
        case .mainBanner:
            return "extra/sliders"
        case .discounts:
            return "discounts"
        case .blogs(let page):
            return "blogs?page=\(page)"
        case .builder:
            return "builder"
        case .html(let url):
            return "pages/\(url)"
        case .blog(let id):
            return "blogs/\(id)"
        case .products:
            return "filter-list"
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
