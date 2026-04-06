//
//  BalancesData.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 16/03/23.
//

import Foundation
public struct BalancesData: Codable {
    public var bank_cards: [BankCardModel]?
    public var total_sum: Double?
}
