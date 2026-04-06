//
//  HistoryData.swift
//  OlchaInvestCore
//
//  Created by Akhrorkhuja on 14/06/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import Foundation

public struct ContractHistoryData: Codable {
    public var contractHistory: [ContractHistoryModel]
}

public struct ContractHistoryModel: Codable {
    public var date: String?
    public var type: HistoryType
    public var type_message: String?
    public var amount: Double?
    
    public enum HistoryType: String, Codable {
        case out
        case `in`
    }
}
