//
//  WithdrawalRequest.swift
//  OlchaInvestCore
//
//  Created by Akhrorkhuja on 08/06/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import Foundation

public struct WithdrawalRequest: Codable {
    public var investor_id: Int
    public var contract_id: Int
    public var bank_card_id: Int
    public var bank_card_alias: String
    public var type: WithdrawalType
    public var amount: Double
    
    public enum WithdrawalType: String, Codable {
        case bankCard = "bank_card"
        case cash = "cash"
    }
}

public struct AutoWithdrawalRequest: Codable {
    public var contract_id: Int
    public var bank_card_id: Int
    public var bank_card_alias: String
    public var percentage: Int
}
