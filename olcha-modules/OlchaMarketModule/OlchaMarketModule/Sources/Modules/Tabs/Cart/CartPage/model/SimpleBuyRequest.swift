//
//  SimpleBuyRequest.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 28/07/22.
//

import Foundation
struct SimpleBuyRequest: Codable {
    let order_type: Int
    let phone_number: String
    let products: [SimpleBuyRequestProduct]
}

struct SimpleBuyRequestProduct: Codable {
    let product_id: Int
    let quantity: Int = 1
}
