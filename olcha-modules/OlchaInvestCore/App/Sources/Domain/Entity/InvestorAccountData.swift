//
//  InvestorAccountData.swift
//  OlchaInvestCore
//
//  Created by Akhrorkhuja on 08/06/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import Foundation

public struct InvestorAccountData: Codable {
    public var investor: InvestorAccountModel
}

public struct InvestorAccountModel: Codable {
    public var id: Int?
    public var full_name: String?
    public var user_id: Int?
    public var created_at: String?
    public var balance_uzs: Double?
    public var balance_usd: Double?
}
