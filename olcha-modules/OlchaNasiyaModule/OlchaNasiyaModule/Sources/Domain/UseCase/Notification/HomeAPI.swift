//
//  NotificationAPI.swift
//  OlchaNasiyaModule
//
//  Created by Elbek Khasanov on 12/05/23.
//

import Foundation
import OlchaUtils
import OlchaCore
public enum HomeAPI {
    case loadLimit
    case requestLimit
}

extension HomeAPI: BaseNasiyaApi {
    
    public var baseURL: String {
        switch self {
        default:
            return Texts.url.nasiya.base
        }
    }
    
    
    public var path: String {
        switch self {
        case .loadLimit:
            return "installment-limit-balance"
        case .requestLimit:
            return "installment-limit-balance/request"
        }
    }
    
    public var version: String {
        switch self {
        case .loadLimit:
            return Texts.url.getVersion(3)
        case .requestLimit:
            return Texts.url.getVersion(3)
        }
    }
    
    public var method: RequestType {
        switch self {
        case .loadLimit:
            return .get
        case .requestLimit:
            return .post

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
