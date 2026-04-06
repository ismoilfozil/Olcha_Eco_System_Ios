//
//  CompareData.swift
//  OlchaMarketModule
//
//  Created by Elbek Khasanov on 07/12/23.
//

import Foundation
class CompareData: Codable {
    
    var comparison_key: String?
    var products: [ProductModel]?
    var categories: [CategoryModel]?
    var product: ProductModel?
    var isCompleted: Bool?
    
    init(comparison_key: String? = nil,
         products: [ProductModel]? = nil,
         categories: [CategoryModel]? = nil,
         product: ProductModel? = nil,
         isCompleted: Bool? = nil
    ) {
        self.comparison_key = comparison_key
        self.products = products
        self.categories = categories
        self.product = product
        self.isCompleted = isCompleted
    }
    
}
