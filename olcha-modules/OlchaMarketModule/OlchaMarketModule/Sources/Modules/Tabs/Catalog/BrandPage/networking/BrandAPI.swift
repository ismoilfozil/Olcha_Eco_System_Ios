//
//  BrandPageAPI.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 20/07/22.
//

import Foundation
import OlchaCore
enum BrandAPI: OlchaMarketAPI {
    case categories(brandID: Int)
    case brands(letter: String, page: Int)
    case sliders(slug: String)
}

extension BrandAPI {
    var queryItems: [URLQueryItem] {
        switch self {
        case .brands(let letter, let page):
            return [
                .init(name: "letter", value: letter.withoutSpace),
                .init(name: "page", value: "\(page)"),
            ]
        default: return []
        }
    }
    
    var path: String {
        switch self {
        case .categories(let brandID):
            return "manufacturers/\(brandID)/categories"
        case .brands:
            return "manufacturers/get-by-letter"
        case .sliders(let slug):
            return "manufacturers/\(slug)/sliders"
        }
    }
    
    var method: RequestType {
        switch self {
        default: return .get
        }
    }
    
    var body: Data? {
        nil
    }
}
