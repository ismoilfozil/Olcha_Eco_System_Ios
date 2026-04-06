//
//  InstallmentAPI.swift
//  OlchaNasiyaModule
//
//  Created by Elbek Khasanov on 11/05/23.
//

import Foundation
import OlchaCore
import OlchaUtils
public enum InstallmentAPI {
    case installments(filter: InstallmentFilter)
    case installment(id: Int)
}

extension InstallmentAPI: BaseNasiyaApi {
    public var path: String {
        switch self {
        case .installments:
            return "user/orders/all"
        case .installment(let id):
            return "user/order/\(id)"
        }
    }
    
    public var version: String {
        switch self {
        case .installments:
            return Texts.url.getVersion(3)
        case .installment:
            return Texts.url.getVersion(3)
        }
    }
    
    public var queryItems: [URLQueryItem] {
        switch self {
        case .installments(let filter):
            
            var items: [URLQueryItem] = [
                .init(name: "page", value: filter.installments.paging.current.string),
                .init(name: "per_page", value: filter.installments.paging.per_page.string)
            ]
            
            if filter.status.key != InstallmentStatus.all.key {
                items.append(.init(name: "status", value: filter.status.key))
            }
            return items
        default:
            return []
        }
    }
    
    public var method: RequestType {
        switch self {
        case .installments:
            return .get
        case .installment:
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
