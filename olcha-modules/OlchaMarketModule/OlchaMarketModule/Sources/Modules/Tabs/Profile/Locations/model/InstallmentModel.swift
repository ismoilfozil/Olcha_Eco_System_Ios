//
//  InstallmentModel.swift
//  NewOlcha
//
//  Created by Muhammadjon on 7/1/21.
//

import Foundation

public struct InstallmentModel : Codable {
    var data: InstallmentData?
    var status: String?
    var message: String?
}

public struct InstallmentData : Codable {
    var installment_id: Int?
    var id : Int?
    
    var total_price: Int?
    var user_id: Int?
    var product_id: Int?
    var instalment_plan_id: Int?
    var created_at: String?
    var comment: String?
    var product_now_price: Int?
    var card_number: String?
    var full_name: String?
    var card_expiry: String?
    var card_type: String?
    var delivery_price: Int?
    
    var mr: Int?
    var first_fee_sum: String?
    var inst_pay_time: Int?
    
//    var is_verified : Int?
    
    
    var order: InstallmentDetail?
    var result: InstallmentResult?
}


