//
//  CartData.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 03/10/22.
//

import Foundation
public class CartCreditData {
    public var first_fee_sum: Int
    public var inst_pay_time: Int
    public var monthly_payment: Int
    public init(first_fee_sum: Int = 0, inst_pay_time: Int = 0, monthly_payment: Int = 0) {
        self.first_fee_sum = first_fee_sum
        self.inst_pay_time = inst_pay_time
        self.monthly_payment = monthly_payment
    }
}

public class CreditOrder {
    public var creditDatas: [CreditType: CartCreditData] = [:]
    public var creditType: CreditType = .olcha
}
