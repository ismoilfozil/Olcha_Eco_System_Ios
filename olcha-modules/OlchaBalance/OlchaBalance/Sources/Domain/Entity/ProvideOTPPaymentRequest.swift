//
//  ProvideOTPPaymentRequest.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 08/11/22.
//

import Foundation
public struct ProvideOTPPaymentRequest: Codable {
    public let transaction: Int
    public let otp: String
}
