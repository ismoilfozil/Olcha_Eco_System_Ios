//
//  PaymentsAPI.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 27/03/23.
//

import Foundation
import OlchaCore
public enum PaymentsAPI {
    case categories
    case providers(categoryID: Int, page: Int)
    case provider(serviceID: Int)
    case providerById(id: Int)
    case phoneCodes
}

extension PaymentsAPI: BaseOlchaPayApi {
    
    
    public var queryItems: [URLQueryItem] {
        switch self {
        case .providers(_ , let page):
            return [.init(name: "page", value: page.string)]
        default:
            return []
        }
    }
    
    
    public var path: String {
        switch self {
        case .categories:
            return "providers/categories/"
        case .providers(let categoryID, _):
            return "providers/category/\(categoryID)/"
        case .provider(let serviceID):
            return "providers/service/\(serviceID)/"
        case .providerById(let providerId):
            return "providers/\(providerId)/"
        case .phoneCodes:
            return "user_profile/phone_codes/"
        }
    }
    
    public var method: RequestType {
        switch self {
        case .categories, .providerById:
            return .get
        case .providers:
            return .get
        case .provider:
            return .get
        case .phoneCodes:
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
