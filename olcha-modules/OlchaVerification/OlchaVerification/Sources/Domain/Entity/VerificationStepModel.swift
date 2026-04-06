//
//  VerificationStepModel.swift
//  NewOlcha
//
//  Created by Muhammadjon on 6/20/21.
//

import Foundation
struct VerificationStepModel : Codable {
    var message: String?
    var status: String?
    var status_code: Int?
    var data: VerificationStepData?
//    var errors: VerificationErrors?
    var passport_expiry_by_date: String?
    var passport_issued_by: String?
    var passport_issued_by_date: String?
    var type: [String]?
    var file: [String]?
}
struct VerificationStepData : Codable {
    var redirect_url: String?
    var errors: Int?
}
struct VerificationErrors : Codable {
//    var work_month_price: String?
    
}
