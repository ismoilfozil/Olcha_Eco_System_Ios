//
//  AddCardOTPError.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 18/03/23.
//

import Foundation
import OlchaCore
public struct VerifyCardOTPRequest: Codable {
    var pan: String?
    var expiry: String?
    var code: String?
    var isTrusted: Bool?
    var cardName: String?
    
    public init(pan: String?, expiry: String?, code: String?, isTrusted: Bool?, cardName: String?) {
        self.pan = pan
        self.expiry = expiry
        self.code = code
        self.isTrusted = isTrusted
        self.cardName = cardName
    }
}

public class VerifyCardOTPError: BaseError {
    var message: String?
    var pan: [String]?
    var expiry: [String]?
    var code: [String]?
    var cardName: [String]?
}
