//
//  ProductsModel.swift
//  NewOlcha
//
//  Created by Muhammadjon on 1/13/21.
//
import OlchaCore
import Foundation
public struct ProductsModel : Codable {
    var status: String?
    var message: String?
    var data: ProductsData?
    
}

public struct ProductsData : Codable {
    var products: [ProductModel]?
    var features: [FullFeature]?
    var filter: Filter?
    var paginator: Paginator?
    var category: CategoryModel?
}

public struct ProductGroup : Codable {
    var id: Int?
    var category_id: Int?
    var name_ru: String?
    var name_uz: String?
    var name_oz: String?
    var alias: String?
    var min_price: String?
    var max_price: String?
    var currency: String?
    var picture: String?
    var products: [ProductModel]?
    
    var name: String?
    func getName() -> String {
        if let name = name {
            return name
        } else {
            return .lang(name_ru,
                         name_uz,
                         name_oz)
        }
    }
}

public class HomeProductsData {
    public var products: [ProductModel] = []
    public var paginator: Paginator?
    public var route: String = ""
}
