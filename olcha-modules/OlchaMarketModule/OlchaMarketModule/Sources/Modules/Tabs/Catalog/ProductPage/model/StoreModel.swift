//
//  Store.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 28/07/22.
//

import UIKit
struct Store : Codable, Equatable {
    var id: Int?
    var name_ru: String?
    var name_uz: String?
    var name_oz: String?
    var is_main: Int?
    var delivery_info_ru: String?
    var delivery_info_uz: String?
    var delivery_info_oz: String?
    
//    var delivery_from_time: Int?
//    var delivery_to_time: Int?
//    var delivery_from_type: Int?
//    var delivery_to_type: Int?
    
    var delivery_method: String?
    var day_of_delivery: String?
    
    var name: String?
    var delivery_location: DeliveryLocation?
    
    init(id: Int?,
         name: String?,
         name_ru: String?,
         name_uz: String?,
         name_oz: String?) {
        self.id = id
        self.name_oz = name_oz
        self.name_uz = name_uz
        self.name_ru = name_ru
        self.name = name
    }
    
    init(id: Int?) {
        self.id = id
    }
    
    func getName() -> String {
        if let name = name {
            return name
        } else {
            return .lang(name_ru,
                         name_uz,
                         name_oz)
        }
    }
    
    var delivery_info: String?
    func getDeliveryInfo() -> String {
        if let delivery_info = delivery_info {
            return delivery_info
        } else {
            return .lang(delivery_info_ru,
                         delivery_info_uz,
                         delivery_info_oz)
        }
    }
    
}

struct DeliveryLocation: Codable, Equatable {
    var id: Int?
    var logo: String?
    var name: String?
}
