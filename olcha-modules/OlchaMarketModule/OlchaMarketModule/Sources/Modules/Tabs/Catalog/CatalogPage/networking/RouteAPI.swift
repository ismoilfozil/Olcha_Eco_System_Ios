//
//  RouteAPI.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 24/08/22.
//

import Foundation
import OlchaCore
enum RouteAPI : OlchaMarketAPI {
    case route(api: String)
}
extension RouteAPI {
    var path: String {
        switch self {
        case .route(let api):
            if !api.isEmpty {
                return String(api.dropFirst())
            } else {
                return ""
            }
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
