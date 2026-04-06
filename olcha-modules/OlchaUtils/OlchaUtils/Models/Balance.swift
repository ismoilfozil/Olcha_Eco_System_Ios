//
//  Balance.swift
//  OlchaUtils
//
//  Created by Elbek Khasanov on 07/05/23.
//

import Foundation
public class Balance: Codable {
    public var id: Int?
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
    
    public init(id: Int? = nil,
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
                max_amount: Int? = nil
    ) {
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
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        do {
            self.id = try container.decodeIfPresent(Int.self, forKey: .id)
        } catch {
            let newValue = try container.decodeIfPresent(String.self, forKey: .id)
            self.id = newValue?.int
        }
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
        } catch {
            let newValue = try container.decodeIfPresent(String.self, forKey: .amount)
            self.amount = newValue?.double
        }
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
        
    }
    
    public func getAmount() -> String {
        amount?.string ?? "0"
    }
}
