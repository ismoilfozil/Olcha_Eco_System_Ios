//
//  FillPaymentRequest.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 08/11/22.
//

import Foundation
public struct FillPaymentRequest: Codable {
    public let alias: String
    public let amount: String
}
