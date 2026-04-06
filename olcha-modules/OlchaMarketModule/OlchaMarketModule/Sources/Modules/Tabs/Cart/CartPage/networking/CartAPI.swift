//
//  CartAPI.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 12/09/22.
//

import Foundation
import OlchaCore
enum CartAPI: OlchaMarketAPI {
    case addFavourites(productID: Int)
    case favourites(page: Int)
    case mergeFavourites
    
    case getCart
    case plusCart(model: CartProducts)
    case minusCart(model: CartProducts)
    case deleteCart(model: CartProducts)
}

extension CartAPI {
    
    var queryItems: [URLQueryItem] {
        switch self {

        case .favourites(let page):
            return [
                .init(name: "page", value: "\(page)")
            ]
        default: return []
        }
    }
    
    var path: String {
        switch self {
        case .addFavourites(let productID):
            return "favorites/\(productID)"
        case .favourites:
            return "favorites"
        case .mergeFavourites:
            return "merge-favorites"
        case .getCart:
            return "carts/get"
        case .plusCart:
            return "carts/add"
        case .minusCart:
            return "carts/minus"
        case .deleteCart:
            return "carts/delete"
        }
    }
    
    var method: RequestType {
        switch self {
        case .plusCart, .minusCart, .deleteCart:
            return .post
        default:
            return .get
        }
    }
    
    var body: Data? {
        var data: Data?
        switch self {
        case .plusCart(let model):
            do {
                data = try JSONEncoder().encode(model)
            } catch {}
            break
        case .minusCart(let model):
            do {
                data = try JSONEncoder().encode(model)
            } catch {}
            break
        case .deleteCart(let model):
            do {
                data = try JSONEncoder().encode(model)
            } catch {}
            break
        default:
            break
        }
        return data
    }
    
}
