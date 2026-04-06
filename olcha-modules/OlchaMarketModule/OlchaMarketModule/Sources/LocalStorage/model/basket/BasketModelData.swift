//
//  BasketModelData.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 28/07/22.
//

import Foundation
struct BasketModelData : Codable {
    var product_id: Int?
    var store_id: Int?
    var product: ProductModel?
    var count: Int?
}
