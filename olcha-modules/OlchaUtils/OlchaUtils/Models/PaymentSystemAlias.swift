//
//  PaymentSystemAlias.swift
//  OlchaUtils
//
//  Created by Elbek Khasanov on 03/07/23.
//

import Foundation
public protocol PaymentSystemAlias: Codable {
    var payment_system_alias: String? { get set }
    var billing_reflection_alias: String? { get set }
}
