//
//  VerificationUploadBankCard.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 20/09/22.
//

import Foundation
import OlchaUtils
public class VerificationUploadBankCard: PaymentSystemAlias {
    public var billing_reflection_alias: String?
    
    public var payment_system_alias: String?
    public let pan: String
    public let expiry: String
    public let phone: String
    public let code: String
    
    public init(pan: String, expiry: String, phone: String, code: String, payment_system_alias: String? = nil) {
        self.pan = pan
        self.expiry = expiry
        self.phone = phone
        self.code = code
        self.payment_system_alias = payment_system_alias
    }
    
    required public init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
}

public class VerificationUploadCode: PaymentSystemAlias {
    public var billing_reflection_alias: String?
    
    public var payment_system_alias: String?
    public let pan: String
    public let expiry: String
    public let phone: String
    
    public init(pan: String, expiry: String, phone: String, payment_system_alias: String? = nil) {
        self.pan = pan
        self.expiry = expiry
        self.phone = phone
        self.payment_system_alias = payment_system_alias
    }
    
    required public init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
}
