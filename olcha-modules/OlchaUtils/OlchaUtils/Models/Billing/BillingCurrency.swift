//
//  BillingCurrency.swift
//  OlchaUtils
//
//  Created by Elbek Khasanov on 10/08/23.
//

import Foundation

//MARK: - Currency
public class BillingCurrency {
    public var order: String? = Texts.currency_alias
    public var payment: String? = Texts.currency_alias
    
    public var amount: Int?
    
    public init(order: String? = nil,
                payment: String? = nil,
                amount: Int? = nil) {
        self.order = order
        self.payment = payment
        self.amount = amount
    }
    
    @discardableResult
    public func set(order: String?) -> Self {
        self.order = order
        return self
    }
    
    @discardableResult
    public func set(payment: String?) -> Self {
        self.payment = payment
        return self
    }
    
    public func getOrder() -> String {
        order ?? Texts.currency_alias
    }
    
    public func getPayment() -> String {
        payment ?? Texts.currency_alias
    }
}
