//
//  CouponModel.swift
//  NewOlcha
//
//  Created by Muhammadjon on 6/10/21.
//

import Foundation
struct CouponModel : Codable {
    var message: String?
    var status: String?
    var data: Coupon?
}

public struct Coupon : Codable {
    var message: String?
    var code: String?
    var value: Int?
    var type: String?
    var apply_discount: String?
    
    func couponNotActive() -> Bool {
        (code ?? "") == ""
    }
    
    func isActiveTitle() -> String {
        couponNotActive() ? "coupon_error".localized() : "coupon_success".localized()
    }
}

struct BonusModel : Codable {
    var message: String?
    var status: String?
    var data: Bonus?
}
class Bonus : Codable {
    var usingBonus: String?
    var bonus: String?
    var bonus_rule: Int?
    
    func getMaximumBonus() -> Int {
        min((bonus_rule ?? 0), (bonus?.int ?? 0))
    }
    
    func checkMaximumBonus() -> Bool {
        return (bonus_rule ?? 0) <= (bonus?.int ?? 0)
    }
}
