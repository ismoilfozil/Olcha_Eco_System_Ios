//
//  InvestmentContractData.swift
//  OlchaInvestCore
//
//  Created by Akhrorkhuja on 12/06/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import Foundation

public enum StatusType: String, Codable {
    case active
    case inactive
    case paused
    case pending_for_payment
}

public struct InvestmentContractData: Codable {
    public var id: Int?
    public var investment_name: String?
    public var contract_name: String?
    public var invest_sum: Double?
    public var profit: String?
    public var profit_balance: String?
    public var percent: Double?
    public var term: Int?
    public var currency: String?
    public var contract_status: Int?
    public var status: Int?
    public var statusBool: Bool {
        status != 0
    }
    public var status_type: StatusType
    public var auto_withdrawal: Bool?
    
    public var unwrappedCurrency: String {
        currency.unwrap.uppercased()
    }
}
