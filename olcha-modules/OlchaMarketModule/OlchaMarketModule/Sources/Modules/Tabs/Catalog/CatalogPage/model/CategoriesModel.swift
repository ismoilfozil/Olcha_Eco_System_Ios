//
//  CategoriesModel.swift
//  NewOlcha
//
//  Created by Muhammadjon on 1/12/21.
//

import Foundation
//CAT == CATEGORY
struct CatModel : Codable {
    var status: String?
    var message: String?
    var data: CatData?
}

struct SubcatModel : Codable {
    var status: String?
    var message: String?
    var data: SubcatData?
}
struct SubcatData : Codable {
    var category: CategoryModel?
}
