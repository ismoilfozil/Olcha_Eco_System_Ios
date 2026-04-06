//
//  PaymentURLModel.swift
//  NewOlcha
//
//  Created by Muhammadjon on 6/15/21.
//

import Foundation
struct PaymentURLModel : Codable {
    var message: String?
    var status: String?
    var data: PaymentURLData?
}

struct PaymentURLData : Codable {
    var redirectUrl : String?
}
