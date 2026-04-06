//
//  PartnerAPI.swift
//  OlchaNasiyaModule
//
//  Created by Elbek Khasanov on 18/05/23.
//

import Foundation
import OlchaUtils
import OlchaCore
public enum PartnerAPI {
    case partners(filter: PartnerFilter)
    case partner(slug: String)
    case regions
    case categories
}

extension PartnerAPI: BaseNasiyaApi {
    public var path: String {
        switch self {
        case .partners:
            return "stores"
        case .partner(let slug):
            return "store/info/\(slug)"
        case .regions:
            return "regions"
        case .categories:
            return "categories"
        }
    }
    
    public var version: String {
        switch self {
        case .partners:
            return Texts.url.getVersion(3)
        case .partner:
            return Texts.url.getVersion(3)
        case .regions:
            return Texts.url.getVersion(3)
        case .categories:
            return Texts.url.getVersion(3)
        default:
            return Texts.url.getVersion()
        }
    }
    
    public var queryItems: [URLQueryItem] {
        switch self {
        case .partners(let filter):
            var queryItems: [URLQueryItem] = [
                .init(name: "page", value: filter.partners.paging.current.string),
                .init(name: "per_page", value: filter.partners.paging.per_page.string)
            ]
            
            if let searchText = filter.searchText {
                queryItems.append(.init(name: "q", value: searchText))
            }
            
            if let categoryID = filter.selectedCategory?.getId() {
                queryItems.append(.init(name: "category", value: categoryID.string))
            }
            
            if let regionID = filter.selectedRegion?.getId() {
                queryItems.append(.init(name: "region", value: regionID.string))
            }
            
            
            return queryItems
        default:
            return []
        }
    }
    
    public var method: RequestType {
        switch self {
        case .partners:
            return .get
        case .partner:
            return .get
        case .regions:
            return .get
        case .categories:
            return .get
        }
    }
    
    public var body: Data? {
        var data: Data?
        switch self {
        default: break
        }
        return data
    }
    
    
}
