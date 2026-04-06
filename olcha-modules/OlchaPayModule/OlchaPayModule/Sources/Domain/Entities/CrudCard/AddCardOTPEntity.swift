//
//  AddCardOTPRequest.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 17/03/23.
//

import Foundation
import OlchaCore
public struct AddCardOTPRequest: Codable {
    var pan: String?
    var expiry: String?
    var cardName: String?
}

public class AddCardOTPError: BaseError {
    var message: String?
    var pan: [String]?
    var expiry: [String]?
    var name: [String]?
}

