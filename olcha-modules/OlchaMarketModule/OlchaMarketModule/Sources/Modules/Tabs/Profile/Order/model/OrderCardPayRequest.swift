//
//  OrderCardPayRequest.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 26/10/22.
//

import Foundation
struct OrderCardPayRequest: Codable {
    var amount: String?
    var card_id: Int?
    var id: String?
}
