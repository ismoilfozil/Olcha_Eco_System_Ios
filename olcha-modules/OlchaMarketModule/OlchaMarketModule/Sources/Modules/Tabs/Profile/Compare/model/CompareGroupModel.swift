//
//  CompareGroupModel.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 15/08/22.
//

import Foundation
class CompareGroupModel {
    var categroy: CategoryModel?
    var products: [ProductModel] = []
    
    init(category: CategoryModel?, products: [ProductModel]) {
        self.categroy = category
        self.products = products
    }
}
