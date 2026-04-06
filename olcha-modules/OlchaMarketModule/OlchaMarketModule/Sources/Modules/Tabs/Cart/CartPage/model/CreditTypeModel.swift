//
//  CreditTypeModel.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 22/02/23.
//

import Foundation
struct CreditTypeModel: Codable {
    var id: Int?
    var logo: String?
    var name: String?
    var disableInitialFee: Bool?
    var plan: CreditTypePlan?
}

struct CreditTypePlan: Codable {
    var initial_fee: Double?
    var min_period: Int?
    var max_period: Int?
}
