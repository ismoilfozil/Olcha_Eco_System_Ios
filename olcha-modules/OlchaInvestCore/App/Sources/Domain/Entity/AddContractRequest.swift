//
//  AddContractRequest.swift
//  OlchaInvestCore
//
//  Created by Akhrorkhuja on 08/06/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import Foundation

public struct AddContractRequest: Codable {
//    public var payment_type: PaymentType
    public var currency: Currency
    public var investment_id: Int
//    public var payment_model_id: Int
    public var investor_id: Int
    public var start_invest: Double
    public var contract_name: String
    
    public enum PaymentType: String, Codable {
        case balance
        case card
        case cash
        case terminal
    }
    
    public enum Currency: String, Codable {
        case uzs
        case usd
    }
}
