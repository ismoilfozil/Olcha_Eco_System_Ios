//
//  Funcs+Mapper.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 24/08/22.
//

import UIKit
import OlchaUI
extension Funcs {
    static func getOrder(id: String?) -> Order {
        return .init(id: id?.int ?? 0)
    }
    
    static func getProductModel(id: Int?,
                                alias: String? = nil,
                                name_ru: String? = nil,
                                name_oz: String? = nil,
                                name_uz: String? = nil
    ) -> ProductModel {
        
        
        return ProductModel(id: id,
                            inStock: nil,
                            name: nil,
                            name_ru: nil,
                            name_oz: nil,
                            name_uz: nil,
                            currency: nil,
                            price: nil,
                            alias: alias,
                            manufacturer_id: nil,
                            category_id: nil,
                            discount: nil,
                            discount_value: nil,
                            discount_type: nil,
                            short_description_ru: nil,
                            short_description_uz: nil,
                            short_description_oz: nil,
                            description_ru: nil,
                            description_uz: nil,
                            description_oz: nil,
                            shipment_count: nil,
                            rating: nil,
                            total_price: nil,
                            images: nil,
                            discount_price: nil,
                            category: nil,
                            main_image: nil,
                            plan_id: nil,
                            has_installment: nil,
                            monthly_repayment: nil,
                            manufacturer: nil,
                            plan: nil,
                            store: nil,
                            mr: nil,
                            quantity: nil,
                            status: nil,
                            weight: nil,
                            warranty_month: nil,
                            recommended: nil,
                            popular: nil,
                            new: nil,
                            sale: nil,
                            product_type: nil,
                            parent_product: nil,
                            is_main: nil,
                            is_like: nil,
                            initial_fee: nil,
                            is_favorite: nil,
                            height_name_ru: nil,
                            height_name_uz: nil,
                            height_name_oz: nil,
                            height_price: nil,
                            characteristics: nil,
                            max_price: nil,
                            store_id: nil
        )
        
    }
    
    static func getCategoryModel(id: Int,
                                 name_ru: String? = nil,
                                 name_uz: String? = nil,
                                 name_oz: String? = nil,
                                 children: [CategoryModel]? = nil) -> CategoryModel {
        return CategoryModel(id: id,
                             parent_id: nil,
                             lft: nil,
                             rgt: nil,
                             depth: nil,
                             name_ru: name_ru,
                             name_uz: name_uz,
                             name_oz: name_oz,
                             icon: nil,
                             alias: nil,
                             active: nil,
                             url_ru: nil,
                             url_uz: nil,
                             url_oz: nil,
                             meta_title_ru: nil,
                             meta_title_uz: nil,
                             meta_title_oz: nil,
                             meta_description_ru: nil,
                             meta_description_uz: nil,
                             meta_description_oz: nil,
                             queue: nil,
                             main_image: nil,
                             images: nil,
                             description_uz: nil,
                             description_ru: nil,
                             description_oz: nil,
                             image: nil,
                             children: children,
                             compareCount: nil,
                             products:nil,
                             background_image: nil)
    }
    
    static func getCategoryModel(alias: String,
                                 id: Int? = nil,
                                 name_ru: String? = nil,
                                 name_uz: String? = nil,
                                 name_oz: String? = nil,
                                 children: [CategoryModel]? = nil) -> CategoryModel {
        return CategoryModel(id: id,
                             parent_id: nil,
                             lft: nil,
                             rgt: nil,
                             depth: nil,
                             name_ru: name_ru,
                             name_uz: name_uz,
                             name_oz: name_oz,
                             icon: nil,
                             alias: alias,
                             active: nil,
                             url_ru: nil,
                             url_uz: nil,
                             url_oz: nil,
                             meta_title_ru: nil,
                             meta_title_uz: nil,
                             meta_title_oz: nil,
                             meta_description_ru: nil,
                             meta_description_uz: nil,
                             meta_description_oz: nil,
                             queue: nil,
                             main_image: nil,
                             images: nil,
                             description_uz: nil,
                             description_ru: nil,
                             description_oz: nil,
                             image: nil,
                             children: children,
                             compareCount: nil,
                             products:nil,
                             background_image: nil)
    }
    
    static func getManufacturer(id: Int? = nil,
                                slug: String? = nil,
                                name_ru: String? = nil,
                                name_uz: String? = nil,
                                name_oz: String? = nil) -> Manufacturer {
        return Manufacturer(id: id,
                            name_ru: name_ru,
                            name_uz: name_uz,
                            name_oz: name_oz,
                            slug: slug,
                            main_image: nil,
                            categories: nil)
    }
    
    public static func jsonMapper(jsonParams: [AnyHashable: Any]) -> CloudMessagingData {
        
        let product_id: String? = jsonParams["product_id"] as? String
        
        let title_ru: String? = jsonParams["title_ru"] as? String
        let title_uz: String? = jsonParams["title_uz"] as? String
        let title_oz: String? = jsonParams["title_oz"] as? String
        
        let name_ru: String? = jsonParams["name_ru"] as? String
        let name_uz: String? = jsonParams["name_uz"] as? String
        let name_oz: String? = jsonParams["name_oz"] as? String
        
        let click_action: String? = jsonParams["click_action"] as? String
        
        let payment_link: String? = jsonParams["payment_link"] as? String
        let order_id: String? = jsonParams["order_id"] as? String
        let link: String? = jsonParams["link"] as? String
        let brand_id: String? = jsonParams["brand_id"] as? String
        let category_id: String? = jsonParams["category_id"] as? String
        
        
        let data = CloudMessagingData(name_ru: name_ru,
                                      name_uz: name_uz,
                                      name_oz: name_oz,
                                      category_id: category_id,
                                      brand_id: brand_id,
                                      product_id: product_id,
                                      
                                      
                                      title_ru: title_ru,
                                      title_uz: title_uz,
                                      title_oz: title_oz,
                                      click_action: click_action,
                                      payment_link: payment_link,
                                      link: link,
                                      order_id: order_id)
        
        return data
    }
    
    static func getFile(_ image: String) -> File {
        return File(full_path: image)
    }
    
    
}
