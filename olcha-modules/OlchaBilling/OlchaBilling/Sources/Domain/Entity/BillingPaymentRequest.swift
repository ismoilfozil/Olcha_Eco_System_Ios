//
//  BillingPaymentRequest.swift
//  OlchaBilling
//
//  Created by Elbek Khasanov on 06/07/23.
//

import Foundation
import OlchaUtils
public class BillingOtpPaymentRequest: PaymentSystemAlias {
    public var payment_system_alias: String?
    public var transaction_id: Int?
    public var otp: String?
    public var billing_reflection_alias: String?
    
    public init(transaction_id: Int?,
                otp: String?,
                payment_system_alias: String?,
                billing_reflection_alias: String?) {
        self.transaction_id = transaction_id
        self.otp = otp
        self.payment_system_alias = payment_system_alias
        self.billing_reflection_alias = billing_reflection_alias
    }
    
    required public init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
    
}

public class GenerateLinkRequest: PaymentSystemAlias {
    public var payment_system_alias: String?
    public var entity_id: Int?
    public var amount: String?
    public var billing_reflection_alias: String?
    
    public init(entity_id: Int?,
                amount: String?,
                payment_system_alias: String?,
                billing_reflection_alias: String?) {
        self.entity_id = entity_id
        self.amount = amount
        self.payment_system_alias = payment_system_alias
        self.billing_reflection_alias = billing_reflection_alias
    }
    
    required public init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
    
    
}

public class BillingConfirmationRequest: PaymentSystemAlias {
    ///Alias for available payment system
    public var payment_system_alias: String?
    
    ///Bank Card ID
    public var payment_entity_id: String?
    
    ///Order ID
    public var entity_id: String?
    
    ///Amount
    public var amount: String?
    
    ///Reflection
    public var billing_reflection_alias: String?
    
    public init(payment_entity_id: String?,
                entity_id: String?,
                amount: String?,
                payment_system_alias: String?,
                billing_reflection_alias: String?) {
        self.payment_entity_id = payment_entity_id
        self.entity_id = entity_id
        self.amount = amount
        self.payment_system_alias = payment_system_alias
        self.billing_reflection_alias = billing_reflection_alias
    }
    
    required public init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
}
