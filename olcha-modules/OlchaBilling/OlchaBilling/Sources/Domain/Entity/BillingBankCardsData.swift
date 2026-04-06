//
//  BillingBankCardsData.swift
//  OlchaBilling
//
//  Created by Elbek Khasanov on 27/06/23.
//

import Foundation
import OlchaBankCards
import OlchaUtils

public class BillingBankCard: Equatable, Codable, CardProtocol {
    
    public static func == (lhs: BillingBankCard, rhs: BillingBankCard) -> Bool {
        lhs.id == rhs.id
    }
    
    public var id: String?
    public var expire_date: String?
    public var number: String?
    public var cardId: Int?
    public var name: String?
    public var phone: String?
    public var is_default: Bool?
    public var amount: Double?
    public var min_amount: Int?
    public var max_amount: Int?
    public var card_icon: String?
    
    public init(id: String?,
                expire_date: String?,
                number: String?,
                cardId: Int?,
                name: String?,
                phone: String?,
                is_default: Bool?,
                min_amount: Int?,
                max_amount: Int?,
                card_icon: String?) {
        self.id = id
        self.expire_date = expire_date
        self.number = number
        self.cardId = cardId
        self.name = name
        self.phone = phone
        self.is_default = is_default
        self.min_amount = min_amount
        self.max_amount = max_amount
        self.card_icon = card_icon
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        do {
            self.id = try container.decodeIfPresent(String.self, forKey: .id)
        } catch {}
        do {
            self.expire_date = try container.decodeIfPresent(String.self, forKey: .expire_date)
        } catch {}
        do {
            self.number = try container.decodeIfPresent(String.self, forKey: .number)
        } catch {}
        do {
            self.cardId = try container.decodeIfPresent(Int.self, forKey: .cardId)
        } catch {}
        do {
            self.name = try container.decodeIfPresent(String.self, forKey: .name)
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
            self.card_icon = try container.decodeIfPresent(String.self, forKey: .card_icon)
        } catch {}
    }
    
    public func getId() -> Int {
        id?.int ?? 0
    }
    public func getFullName() -> String {
        name ?? ""
    }
    public func getNumber() -> String {
        number ?? ""
    }
    public func getExpire() -> String {
        expire_date ?? ""
    }
    public func getLogoURL() -> String {
        card_icon ?? ""
    }
    public func getIsDefault() -> Bool {
        is_default ?? false
    }
    public func getAmount() -> Double {
        amount ?? 0
    }
}

public class BillingBalance: Equatable, Codable {
    
    public static func == (lhs: BillingBalance, rhs: BillingBalance) -> Bool {
        lhs.id == rhs.id
    }
    
    public var id: String?
    public var owner_type: String?
    public var owner_id: Int?
    public var type: String?
    public var currency_id: Int?
    public var amount: Double?
    public var active: Int?
    public var is_default: Int?
    public var is_exchangeable: Int?
    public var created_at: String?
    public var min_amount: Int?
    public var max_amount: Int?
    public var logo: String?
    public var billing_reflection_alias: String?
    
    public init(id: String? = nil,
                owner_type: String? = nil,
                owner_id: Int? = nil,
                type: String? = nil,
                currency_id: Int? = nil,
                amount: Double? = nil,
                active: Int? = nil,
                is_default: Int? = nil,
                is_exchangeable: Int? = nil,
                created_at: String? = nil,
                min_amount: Int? = nil,
                max_amount: Int? = nil,
                logo: String? = nil,
                billing_reflection_alias: String?) {
        self.id = id
        self.owner_type = owner_type
        self.owner_id = owner_id
        self.type = type
        self.currency_id = currency_id
        self.amount = amount
        self.active = active
        self.is_default = is_default
        self.is_exchangeable = is_exchangeable
        self.created_at = created_at
        self.min_amount = min_amount
        self.max_amount = max_amount
        self.logo = logo
        self.billing_reflection_alias = billing_reflection_alias
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        do {
            self.id = try container.decodeIfPresent(String.self, forKey: .id)
        } catch {}
        do {
            self.owner_type = try container.decodeIfPresent(String.self, forKey: .owner_type)
        } catch {}
        do {
            self.owner_id = try container.decodeIfPresent(Int.self, forKey: .owner_id)
        } catch {}
        do {
            self.type = try container.decodeIfPresent(String.self, forKey: .type)
        } catch {}
        do {
            self.currency_id = try container.decodeIfPresent(Int.self, forKey: .currency_id)
        } catch {}
        do {
            self.amount = try container.decodeIfPresent(Double.self, forKey: .amount)
        } catch {}
        do {
            self.active = try container.decodeIfPresent(Int.self, forKey: .active)
        } catch {}
        do {
            self.is_default = try container.decodeIfPresent(Int.self, forKey: .is_default)
        } catch {}
        do {
            self.is_exchangeable = try container.decodeIfPresent(Int.self, forKey: .is_exchangeable)
        } catch {}
        do {
            self.created_at = try container.decodeIfPresent(String.self, forKey: .created_at)
        } catch {}
        do {
            self.logo = try container.decodeIfPresent(String.self, forKey: .logo)
        } catch {}
        do {
            self.billing_reflection_alias = try container.decodeIfPresent(String.self, forKey: .billing_reflection_alias)
        } catch {}
    }
    
}

public struct BillingEntitiesData: Codable {
    public var collection: [BillingCollectionItem]?
}

public struct BillingCollectionItem: Codable {
    public var balance: BillingBalance?
    public var bank_cards: [BillingBankCard]?
    public var is_replenishable: Bool?
    public var currency: String?
    public var min_amount: Int?
    public var max_amount: Int?
    public var alias: String?
    public var name: String?
    public var logo: String?
    
    public var bankCards: [BillingBankCard] {
        bank_cards ?? []
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        do {
            self.balance = try container.decodeIfPresent(BillingBalance.self, forKey: .balance)
        } catch {}
        do {
            self.bank_cards = try container.decodeIfPresent([BillingBankCard].self, forKey: .bank_cards)
        } catch {}
        do {
            self.is_replenishable = try container.decodeIfPresent(Bool.self, forKey: .is_replenishable)
        } catch {}
        do {
            self.currency = try container.decodeIfPresent(String.self, forKey: .currency)
        } catch {}
        do {
            self.min_amount = try container.decodeIfPresent(Int.self, forKey: .min_amount)
        } catch {}
        do {
            self.max_amount = try container.decodeIfPresent(Int.self, forKey: .max_amount)
        } catch {}
        do {
            self.alias = try container.decodeIfPresent(String.self, forKey: .alias)
        } catch {}
        do {
            self.name = try container.decodeIfPresent(String.self, forKey: .name)
        } catch {}
        do {
            self.logo = try container.decodeIfPresent(String.self, forKey: .logo)
        } catch {}
    }
    
    
}

