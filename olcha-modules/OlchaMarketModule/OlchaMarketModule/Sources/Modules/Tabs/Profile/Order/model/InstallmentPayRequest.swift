//
//  InstallmentPayRequest.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 26/10/22.
//

import Foundation
struct InstallmentPayRequest: Codable {
    var payment: String?
    var payment_type: String?
    var order_id: Int?
}
