//
//  BillingFilter.swift
//  OlchaBankCards
//
//  Created by Elbek Khasanov on 11/07/23.
//

import Foundation

public class BillingPaymentFilter {
    ///
    /// Default amount
    ///
    public var amount: Int?
    ///
    /// OTP when paying with card
    ///
    public var otp: String?
    ///
    /// When OTP sent you will get transaction_id
    ///
    public var transaction_id: String?
    ///
    /// Billing settings, which includes reflection and collection_type.
    ///
    public var settings = BillingSettings()
    ///
    /// Payment is when you select payment type, webhook(click, payme), bank-cards, balance
    ///
    public var payment = BilllingPaymentModel()
    ///
    /// Comes from when starts billing. You have to fill order.
    ///
    public var order = BillingOrderModel()
    ///
    /// Hides/shows pay all button
    ///
    public var isPayAllButtonHidden: Bool = false
    ///
    /// Enable/disable amount field
    ///
    public var isAmountFieldDisabled: Bool = false
    ///
    /// Check currency equality
    ///
    public var isCurrencyEqual : Bool {
        getOrderCurrency().lowercased() == getPaymentCurrency().lowercased()
    }
    
    public init(amount: Int? = nil,
                otp: String? = nil,
                transaction_id: String? = nil,
                order: BillingOrderModel = BillingOrderModel(),
                settings: BillingSettings = BillingSettings()) {
        self.amount = amount
        self.otp = otp
        self.transaction_id = transaction_id
        self.order = order
        self.settings = settings
    }
}

//MARK: - Setters
public extension BillingPaymentFilter {
    
    func set(payment_alias: String?) -> Self {
        payment.alias = payment_alias ?? ""
        return self
    }
    
    func set(reflection: Reflection?) -> Self {
        settings.set(reflection: reflection)
        return self
    }
    
    func set(collectionType: BillingCollectionType) -> Self {
        settings.set(collectionType: collectionType)
        return self
    }
    
    func set(amount: Int?) -> Self {
        self.amount = amount
        return self
    }
    @discardableResult
    func set(max_value: Int?) -> Self {
        self.order.max_value = max_value
        return self
    }
    @discardableResult
    func set(min_value: Int?) -> Self {
        self.order.min_value = min_value
        return self
    }
    @discardableResult
    func set(transaction_id: String?) -> Self {
        self.transaction_id = transaction_id
        return self
    }
    @discardableResult
    func set(otp: String?) -> Self {
        self.otp = otp
        return self
    }
    ///entity_id
    func set(order_id: Int?) -> Self {
        self.order.id = order_id
        return self
    }
    ///payment_entity_id
    func set(payment_id: Int?) -> Self {
        self.payment.id = payment_id
        return self
    }
    
    ///entity_currency
    @discardableResult
    func set(order_currency: String?) -> Self {
        self.order.currency = order_currency ?? Texts.currency_alias
        return self
    }
    ///payment_entity_currenycy
    @discardableResult
    func set(payment_currency: String?) -> Self {
        self.payment.currency = payment_currency ?? Texts.currency_alias
        return self
    }
    ///isPayAllButtonHidden
    @discardableResult
    func payAllButton(hidden: Bool) -> Self {
        self.isPayAllButtonHidden = hidden
        return self
    }
    ///isAmountFieldDisabled
    @discardableResult
    func amountField(disabled: Bool) -> Self {
        self.isAmountFieldDisabled = disabled
        return self
    }
}

//MARK: - Getters
public extension BillingPaymentFilter {
    
    func getEntityID() -> Int? {
        order.id
    }
    
    func getReflection() -> String {
        settings.reflection
    }
    
    ///entity_currency
    func getOrderCurrency() -> String {
        order.getCurrency()
    }
    
    ///payment_entity_currenycy
    func getPaymentCurrency() -> String {
        payment.getCurrency()
    }
    
    func getPaymentEntityID() -> Int? {
        payment.id
    }
    
    func getPaymentAlias() -> String {
        payment.alias ?? ""
    }
    
    func getMaxAmount() -> Int {
        if let paymentValue = payment.max_value,
           let orderValue = order.max_value {
            if orderValue > paymentValue {
                return paymentValue
            }
            return orderValue
        } else {
            return payment.max_value ?? order.max_value ?? 0
        }
    }
    
    func getMinAmount() -> Int {
        if let paymentValue = payment.min_value,
           let orderValue = order.min_value {
            if orderValue < paymentValue {
                return paymentValue
            }
            return orderValue
        } else {
            return payment.min_value ?? order.min_value ?? 0
        }
    }
 
    ///`Balance`, `Bank Card` cash amount
    func getCurrentAmount() -> Double? {
        payment.current_amount
    }
}
