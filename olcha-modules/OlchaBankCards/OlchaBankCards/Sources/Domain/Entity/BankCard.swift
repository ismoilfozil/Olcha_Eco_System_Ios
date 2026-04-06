//
//  BankCard.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 20/09/22.
//

import Foundation
public struct BankCardsData: Codable {
    public init() {}
    public var bank_cards: [BankCard]?
}

public class BankCard: Equatable, Codable {
    public static func == (lhs: BankCard, rhs: BankCard) -> Bool {
        lhs.id == rhs.id
    }
    
    public var id: Int?
    public var card_expiry: String?
    public var card_number: String?
    public var cardId: Int?
    public var full_name: String?
    public var phone: String?
    public var is_default: Bool?
    public var amount: Double?
    
    public var min_amount: Int?
    public var max_amount: Int?
    
    public init() {}
    
    public init(id: Int?,
                card_expiry: String?,
                card_number: String?,
                cardId: Int?,
                full_name: String?,
                phone: String?,
                is_default: Bool?,
                min_amount: Int? = 1_000,
                max_amount: Int? = nil
    ) {
        self.id = id
        self.card_expiry = card_expiry
        self.card_number = card_number
        self.cardId = cardId
        self.full_name = full_name
        self.phone = phone
        self.is_default = is_default
        self.min_amount = min_amount
        self.max_amount = max_amount
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        do {
            self.id = try container.decodeIfPresent(Int.self, forKey: .id)
        } catch {}
        do {
            self.card_expiry = try container.decodeIfPresent(String.self, forKey: .card_expiry)
        } catch {}
        do {
            self.card_number = try container.decodeIfPresent(String.self, forKey: .card_number)
        } catch {}
        do {
            self.cardId = try container.decodeIfPresent(Int.self, forKey: .cardId)
        } catch {}
        do {
            self.full_name = try container.decodeIfPresent(String.self, forKey: .full_name)
        } catch {}
        do {
            self.phone = try container.decodeIfPresent(String.self, forKey: .phone)
        } catch {}
        do {
            self.is_default = try container.decodeIfPresent(Bool.self, forKey: .is_default)
        } catch {}
        do {
            self.amount = try container.decodeIfPresent(Double.self, forKey: .amount)
        } catch {}
        do {
            self.min_amount = try container.decodeIfPresent(Int.self, forKey: .min_amount)
        } catch {}
        do {
            self.max_amount = try container.decodeIfPresent(Int.self, forKey: .max_amount)
        } catch {}
    }
}


public struct BankCardData: Codable {
    public var data: BankCard?
}
