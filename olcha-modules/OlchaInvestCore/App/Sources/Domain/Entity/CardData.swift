//
//  CardData.swift
//  OlchaInvestCore
//
//  Created by Akhrorkhuja on 22/05/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import Foundation
import OlchaCore

public struct CardData: Codable {
    public var cards: [CardModel]
    
    public static func mock() -> CardData {
        return CardData(cards: [
//            .mock(id: 1),
//            .mock(id: 2),
//            .mock(id: 3),
//            .mock(id: 4),
        ])
    }
}

public class CardModel: Codable {
    public var id: Int?
    public var name: String?
    public var number: String?
    public var active: Bool?
    public var expireDate: String?
    public var amount: Double?
    public var is_exchangeable: Bool?
    public var currency: String?
    public var type: String?
    
    public var isSelected: Bool?
}

public struct CardSendOtpRequest: Codable {
    public var pan: String
    ///yy/MM
    public var expiry: String
    public var phone: String
}

public struct CardSendOtpResponse: Codable {
    public var is_card_exists: Bool
}

public struct CardConfirmOtpRequest: Codable {
    public var pan: String
    ///yy/MM
    public var expiry: String
    public var phone: String
    public var code: String
}
