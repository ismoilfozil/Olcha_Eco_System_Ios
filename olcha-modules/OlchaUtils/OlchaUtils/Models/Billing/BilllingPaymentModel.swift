//
//  BillingSelectedPayment.swift
//  OlchaUtils
//
//  Created by Elbek Khasanov on 10/08/23.
//

import Foundation
public struct ReflectionType {
//    public static let order = "998057fb-3df1-4a68-b62a-3ba81dd7d9d5"
    public static let nasiya_all_bank_cards = "st_nasiya_bank_card_group"
    public static let nasiya_all_balance = "st_olcha_nasiya_balance_group"
    
    public static let invest_all_balance = "st_olcha_invest_balance_group"
    public static let invest_all_bank_cards = "st_olcha_invest_bank_card_group"
//    public static let invest_contract = "st_olcha_invest_contract"
}

//MARK: - Selected payment
public class BilllingPaymentModel {
    public enum PaymentState {
        case bankCard
        case balance
        case webhook
        case none
    }
    
    public enum OtpState {
        case `default`
        case otp
        case payment
    }
    
    public var min_value: Int?
    public var max_value: Int?
    ///
    ///  - `Balance`, `Bank Card` cash amount
    ///
    public var current_amount: Double?
    public var alias: String?
    public var id: Int?
    
    public var currency: String? = Texts.currency_alias
//    public var reflection: Reflection = ReflectionType.all_balance
    
    public var paymentState: PaymentState = .none {
        didSet {
            otpState = .default
        }
    }
    
    public var otpState: OtpState = .default
    
    public func set(min_value: Int? = nil,
                    max_value: Int? = nil) {
        self.min_value = min_value
        self.max_value = max_value
    }
    
    public func setIdentifier(alias: String?,
                              id: Int?) {
        self.id = id
        self.alias = alias
    }

    public func setCurrentAmount(value: Double? = nil) {
        self.current_amount = value
    }
    
    public func checkIdentifier(alias: String?,
                                id: Int?) -> Bool {
        (self.alias == alias) && (self.id == id)
    }
    
    public func getCurrency() -> String {
        currency ?? Texts.currency_alias
    }
}
