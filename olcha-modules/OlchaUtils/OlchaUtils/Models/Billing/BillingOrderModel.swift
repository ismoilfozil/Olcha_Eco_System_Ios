//
//  BillingModel.swift
//  OlchaUtils
//
//  Created by Elbek Khasanov on 04/08/23.
//

import Foundation

public class BillingOrderModel {
    /// Order, contract, invest, blance id
    public var id: Int?
    /// Max value of typing amount
    public var max_value: Int?
    /// Min value of typing amount
    public var min_value: Int?
    /// Order, contract, invest, balance currency. Default is "UZS"
    public var currency: String?
    /// Order, contract, invest, balance should pay
    public var current_value: Int?
    
    public init(id: Int? = nil,
                max_value: Int? = nil,
                min_value: Int? = nil,
                currency: String? = nil,
                current_value: Int? = nil
    ) {
        self.id = id
        self.max_value = max_value
        self.min_value = min_value
        self.currency = currency
        self.current_value = current_value
    }
    
    public func getCurrency() -> String {
        currency ?? Texts.currency_alias
    }
    
}
