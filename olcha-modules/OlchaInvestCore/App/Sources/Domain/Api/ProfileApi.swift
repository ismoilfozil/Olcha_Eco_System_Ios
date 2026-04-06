//
//  ProfileAPI.swift
//  OlchaNasiyaModule
//
//  Created by Elbek Khasanov on 23/05/23.
//

import Foundation
import OlchaUtils
import OlchaCore
public enum ProfileAPI {
    case user
    case editUser(model: InvestUser)
}

extension ProfileAPI: InvestBaseApi {
    public var baseURL: String {
        switch self {
        case .user:
            return "https://647ee5eac246f166da8f9890.mockapi.io/mockapi"
        case .editUser:
            return "https://647ee5eac246f166da8f9890.mockapi.io/mockapi"
        }
    }
    
    public var version: String {
        switch self {
        case .user:
            return Texts.url.getVersion(1)
        case .editUser:
            return Texts.url.getVersion(1)
        }
    }
    
    public var path: String {
        switch self {
        case .user:
            return "profile/1"
        case .editUser:
            return "profile/1"
        }
    }
    
    public var method: RequestType {
        switch self {
        case .user:
            return .get
        case .editUser:
            return .put
        }
    }
    
    public var body: Data? {
        var data: Data?
        switch self {
        case .editUser(let model):
            data = encode(model)
            break
        default: break
        }
        return data
    }
    
    
}
