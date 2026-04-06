//
//  BalancePayRequest.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 30/11/22.
//

import Foundation
struct BalancePayRequest: Codable {
    let amount: Int
    let order_id: Int
}
