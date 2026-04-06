//
//  LocationAPI.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 08/09/22.
//

import Foundation
import OlchaCore
enum LocationAPI: OlchaMarketAPI {

    case usersLocations(page: Int)
    case makeDefault(id: Int)
    case delete(id: Int)
    case create(address: UserAddress)
    case update(id: Int, address: UserAddress)
    case districts(regionID: Int)
    case regions
    
}

extension LocationAPI {
    var queryItems: [URLQueryItem] {
        switch self {
        case .usersLocations(let page):
            return [.init(name: "page", value: "\(page)")]

        case .districts(let regionID):
            return [.init(name: "region_id", value: "\(regionID)")]
        default: return []
        }
    }
    
    var path: String {
        switch self {
        case .usersLocations:
            return "user/address"
        case .makeDefault(let id):
            return "user/default/address/change/\(id)"
        case .delete(let id):
            return "user/address/delete/\(id)"
        case .create:
            return "user/address/create"
        case .update(let id, _):
            return "user/address/update/\(id)"
        case .districts:
            return "order/districts"
        case .regions:
            return "order/districts"
        }
    }
    
    var method: RequestType {
        switch self {
        case .create:
            return .post
        case .update:
            return .put
        default:
            return .get
        }
    }
    
    var body: Data? {
        var data: Data?
        switch self {

        case .create(let address):
            do {
                data = try JSONEncoder().encode(address)
            } catch {}
            break
        case .update( let _, let address):
            
            do {
                data = try JSONEncoder().encode(address)
            } catch {}
            break
            
        default:
            data = nil
            break
        }
        return data
    }
    
}
