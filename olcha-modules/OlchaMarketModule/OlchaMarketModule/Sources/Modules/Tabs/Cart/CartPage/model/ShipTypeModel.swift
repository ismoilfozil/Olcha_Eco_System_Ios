//
//  ShipTypeModel.swift
//  NewOlcha
//
//  Created by Muhammadjon on 6/1/21.
//

import Foundation

struct ShipTypeModel : Codable {
    var message: String?
    var status: String?
    var data: ShipTypeData?
}
struct ShipTypeData : Codable {
    var deliveries: [Delivery]?
}
struct Delivery : Codable, Equatable {
    var id: Int?
    var region_id: Int?
    var district_id: Int?
    var name_ru: String?
    var name_uz: String?
    var name_oz: String?
    var description_ru: String?
    var description_uz: String?
    var description_oz: String?
    var price: Int?
    var min_total_cost: Int?
    var extra_price: Int?
    var max_weight:  String?
    var weight_price: Int?
    var delivered_time_oz: String?
    var delivered_time_uz: String?
    var delivered_time_ru: String?
    var delivered_time: String?
    var weight_every: Int?
    var installment: Int?
    var status: Int?
    var checkout_type: String?
    var type: String?
    
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
    
    func getDeliveredTime() -> String {
        if let delivered_time = delivered_time {
            return delivered_time
        } else {
            return .lang(delivered_time_ru,
                         delivered_time_uz,
                         delivered_time_oz)
        }
    }
}


enum ShipType {
    case delivery
    case pickup
    case express
}
