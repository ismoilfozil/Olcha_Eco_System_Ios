//
//  MakeTransactionRequest.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 04/04/23.
//

import Foundation
import OlchaUtils
public struct MakeTransactionGetOtpRequest: Codable {
    let service_id: Int
    let card_id: Int
    let provider_id: Int
    
    let fields: [TransactionKeyValueModel]
}

public struct MakeTransactionVerifyOtpRequest: Codable {
    var session: Int?
    var otp_code: String?
    var transaction_id: Int?
}
