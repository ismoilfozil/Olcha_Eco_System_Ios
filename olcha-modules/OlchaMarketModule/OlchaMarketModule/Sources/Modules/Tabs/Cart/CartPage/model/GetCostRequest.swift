//
//  GetCostRequest.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 05/10/22.
//

import Foundation

protocol GetCostProtocol: AnyObject, Codable {
    var products: [[String: Int]]? { get set }
    var name: String? { get set }
    var phone: String? { get set }
    var email: String? { get set }
    var region_id: Int? { get set }
    var district_id: Int? { get set }
    var delivery_id: Int? { get set }
    var address_id: Int? { get set }
    
    var street: String? { get set }
    var entrance: String? { get set }
    var floor: String? { get set }
    var house_number: String? { get set }
    
    var payment_type: String? { get set }
    var comment: String? { get set }
    var coupon: String? { get set }
    
    var first_fee_sum: Int? { get set }
    var inst_pay_time: Int? { get set }
    var order_type: String? { get set }
}
//class GetCostRequest: GetCostProtocol {
//    var products: [[String : Int]]?
//    var name: String?
//    var phone: String?
//    var email: String?
//    var region_id: Int?
//    var district_id: Int?
//    var delivery_id: Int?
//    var address_id: Int?
//    var street: String?
//    var entrance: String?
//    var floor: String?
//    var house_number: String?
//    var payment_type: String?
//    var comment: String?
//    var coupon: String?
//    var first_fee_sum: Int?
//    var inst_pay_time: Int?
//    var order_type: String?
//    var type: String = "ios"
//    var checkout_type: String = "delivery"
//    
//    
//    init(products: [[String : Int]]?, name: String?, phone: String?, email: String?, region_id: Int?, district_id: Int?, delivery_id: Int?, address_id: Int?, street: String?, entrance: String?, floor: String?, house_number: String?, payment_type: String?, comment: String?, coupon: String?, first_fee_sum: Int?, inst_pay_time: Int?, order_type: String?) {
//        self.products = products
//        self.name = name
//        self.phone = phone
//        self.email = email
//        self.region_id = region_id
//        self.district_id = district_id
//        self.delivery_id = delivery_id
//        self.address_id = address_id
//        self.street = street
//        self.entrance = entrance
//        self.floor = floor
//        self.house_number = house_number
//        self.payment_type = payment_type
//        self.comment = comment
//        self.coupon = coupon
//        self.first_fee_sum = first_fee_sum
//        self.inst_pay_time = inst_pay_time
//        self.order_type = order_type
//    }
//}

class GetCostRequest: Encodable {
    var products: [[String : Int]]?
    var name: String?
    var phone: String?
    var email: String?
    var region_id: Int?
    var district_id: Int?
    var delivery_id: Int?
    var address_id: Int?
    var street: String?
    var entrance: String?
    var floor: String?
    var house_number: String?
    @NullEncodable var payment_type: String?
    var comment: String?
    var coupon: String?
    var first_fee_sum: Int?
    var inst_pay_time: Int?
    var order_type: String?
    var bonus: Int?
    
    var type: String = "ios"
    var checkout_type: String = "delivery"
    
    init(products: [[String : Int]]?, name: String?, phone: String?, email: String?, region_id: Int?, district_id: Int?, delivery_id: Int?, address_id: Int?, street: String?, entrance: String?, floor: String?, house_number: String?, payment_type: String?, comment: String?, coupon: String?, first_fee_sum: Int?, inst_pay_time: Int?, order_type: String?, bonus: Int?) {
        self.products = products
        self.name = name
        self.phone = phone
        self.email = email
        self.region_id = region_id
        self.district_id = district_id
        self.delivery_id = delivery_id
        self.address_id = address_id
        self.street = street
        self.entrance = entrance
        self.floor = floor
        self.house_number = house_number
        self.payment_type = payment_type
        self.comment = comment
        self.coupon = coupon
        self.first_fee_sum = first_fee_sum
        self.inst_pay_time = inst_pay_time
        self.order_type = order_type
        self.bonus = bonus
    }
    
    

}
