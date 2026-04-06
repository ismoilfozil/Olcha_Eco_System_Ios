//
//  SaveTransactionRequest.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 02/04/23.
//

import Foundation
import OlchaUtils
public struct SaveTransactionRequest: Codable {
    var name: String?
    var type: String? = "paynet"
    var provider_service_id: Int?
    var service_price: Double?
    var service_discount: Double? = 0
    var fields: [TransactionKeyValueModel]?
}
