//
//  StoreProductsData.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 28/07/22.
//

import Foundation
class StoreProductsData: Codable {
    var id: Int?
    var price: Int?
    var quantity: Int?
    var status: String?
    var discount_price: Int?
    var gifts: [ProductModel]?
    var store: Store?
    var cart_count: Int?
    var warranty: Int?
    var warranty_type: String?
    
    func getProductModel(_ product: ProductModel?) -> ProductModel? {
        var newProduct = product
        newProduct?.store_id = id
        return newProduct
    }
}
