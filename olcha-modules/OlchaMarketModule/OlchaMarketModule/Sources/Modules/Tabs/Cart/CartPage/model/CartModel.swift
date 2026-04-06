//
//  CartModel.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 13/09/22.
//

import Foundation

struct CartData: Codable {
    var cart: CartModel?
}

class CartModel: Codable {
    var key: String?
    var coupon: String?
    var cart_items: [CartItem]?
}

struct CartProducts: Codable {
    var cart_items: [CartItem]?
}

class CartItem: Codable {
    var product_id: Int?
    var store_id: Int?
    var quantity: Int?
    
    init(product_id: Int?, store_id: Int?, quantity: Int?) {
        self.product_id = product_id
        self.store_id = store_id
        self.quantity = quantity
    }
}
