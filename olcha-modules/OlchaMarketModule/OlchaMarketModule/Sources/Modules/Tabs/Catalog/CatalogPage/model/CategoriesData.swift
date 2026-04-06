//
//  CategoriesData.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 04/07/22.
//

import Foundation
struct CatData : Codable {
    var categories: [CategoryModel]?
    var parent_categories: [CategoryModel]?
}

struct CategoryData: Codable {
    var category: CategoryModel?
}
