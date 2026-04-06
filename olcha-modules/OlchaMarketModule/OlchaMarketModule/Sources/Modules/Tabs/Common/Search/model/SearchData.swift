//
//  SearchProductModel.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 31/10/22.
//

import Foundation

struct SearchModel: Codable {
    var message: String?
    var status_code: Int?
    
    var products: [SearchProductData]?
    var brands: [SearchBrandData]?
    var category: [SearchCategoryData]?
}

struct SearchProductData: Codable {
    var _source: ProductModel?
}

struct SearchBrandData: Codable {
    var _source: Manufacturer?
}

struct SearchCategoryData: Codable {
    var _source: CategoryModel?
}
