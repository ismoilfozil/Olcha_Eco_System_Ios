//
//  DiscountsModel.swift
//  NewOlcha
//
//  Created by Muhammadjon on 7/22/21.
//

import Foundation
struct DiscountsModel : Codable {
    var message : String?
    var status: String?
    var data: DiscountsData?
}



struct Discount : Codable {
    var id: Int?
    var name_ru: String?
    var name_uz: String?
    var name_oz: String?
    var apply_discount: String?
    var value: Int?
    var type: String?
    var total_available: Int?
    var start_date: String?
    var end_date: String?
    var status: Int?
    var main_image: String?
    var link: String?
    
    var main_image_uz: String?
    var main_image_oz: String?
    var main_image_ru: String?
    
    var main_image_mobile: String?
    var main_image_mobile_uz: String?
    var main_image_mobile_ru: String?
    var main_image_mobile_oz: String?
    
    func getMainMobileImage() -> String {
        if let main_image_mobile = main_image_mobile {
            return main_image_mobile
        } else {
            return .lang(main_image_mobile_ru,
                         main_image_mobile_uz,
                         main_image_mobile_oz)
        }
    }
    
    func getMainImage() -> String {
        if let main_image = main_image {
            return main_image
        } else {
            return .lang(main_image_ru,
                         main_image_uz,
                         main_image_oz)
        }
    }
    
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
