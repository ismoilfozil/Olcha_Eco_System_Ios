//
//  HomeModel.swift
//  NewOlcha
//
//  Created by Muhammadjon on 1/11/21.
//

import Foundation
struct HomeModel : Codable {
    var status: String?
    var message: String?
    var data: HomeData?
}

struct HomeData : Codable {
    var sliders: [Slider]?
    var blogs: [Blog]?
    var popular_products: [ProductModel]?
    var recommended_products: [ProductModel]?
    var discount_text: DiscountTextModel?
    var often_needed: [ProductModel]?
    var also_buy: [ProductModel]?
    var new_products: [ProductModel]?
    var discount_products: [ProductModel]
    var history_products: [ProductModel]?
    var categories: [CategoryModel]?
    var banners: [Slider]?
}


struct OftenNeededModel : Codable {
    var new_products: ProductModel?
}
struct DiscountTextModel : Codable {
    var title_ru: String?
    var title_uz: String?
    var title_oz: String?
    var description_ru: String?
    var description_uz: String?
    var description_oz: String?
    
    var description: String?
    
    func getDescription() -> String {
        if let description = description {
            return description
        } else {
            return .lang(description_ru,
                         description_uz,
                         description_oz)
        }
    }
    
    var title: String?
    
    func getTitle() -> String {
        if let title = title {
            return title
        } else {
            return .lang(title_ru,
                         title_uz,
                         title_oz)
        }
    }
    
}
