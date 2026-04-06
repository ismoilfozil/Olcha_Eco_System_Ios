//
//  AutoWithdrawalData.swift
//  OlchaInvestCore
//
//  Created by Akhrorkhuja on 17/06/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import Foundation

public struct AutoWithdrawalData: Codable {
    public var autoWithdrawal: AutoWithdrawalModel
}

public struct AutoWithdrawalModel: Codable {
    public var id: Int?
    public var bank_card_id: Int?
    public var balance_id: Int?
    public var percentage: Int?
    public var is_active: Int?
    public var created_at: String?
    public var updated_at: String?
}

public struct ToggleAutoWithdrawalResponse: Codable {
    public var is_active: Bool
}
