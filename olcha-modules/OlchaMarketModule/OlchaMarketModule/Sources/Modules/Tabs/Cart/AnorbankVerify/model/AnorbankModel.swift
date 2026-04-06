//
//  AddAnorbankRequest.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 15/11/22.
//

import Foundation
import OlchaCore
public struct AddAnorbankRequest: Codable {
    public let expiry: String
    public let order_id: Int
    public let pan: String
    
    init(expiry: String, order_id: Int, pan: String) {
        self.expiry = expiry
        self.order_id = order_id
        self.pan = pan
    }
}

public struct AddAnorbankResponse: Codable {
    public var payment_id: Int?
    public var phone: String?
    public var left_seconds: Int?
    public var amount: Int?
}

public struct VerifyAnorbankRequest: Codable {
    public let payment_id: Int
    public let otp: String
    
    init(payment_id: Int, otp: String) {
        self.payment_id = payment_id
        self.otp = otp
    }
}

public struct VerifyAnorbankResponse: Codable {
    public var success: Bool?
    public var message: String?
    public var responseText: String?
}

public struct MessageData: Codable {
    public var message: String?
    public var paginator: Paginator?
}
