//
//  BankCardEntity.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 15/03/23.
//

import Foundation
public enum BankType: String {
    case humo
    case uzcard
    case none
}

public class UserBankCardModel: Codable, Equatable {
    public static func == (lhs: UserBankCardModel, rhs: UserBankCardModel) -> Bool {
        (lhs.id ?? -1) == (rhs.id ?? -2)
    }
    
    var id: Int?
    var color: String?
    var status: String?
    var cardName: String?
    var bank_card: BankCardModel?
    var transactions: [TransactionModel]?
    
    var isDefault: Bool {
        get {
            return (status ?? "secondary") == "main"
        }
        
        set {
            if newValue {
                status = "main"
            } else {
                status = "secondary"
            }
        }
    }
    
    var bankName: String {
        (bank_card?.getSpacedPan() ?? "") + " " + (cardName ?? "")
    }
    
    var balanceAmount: String? {
        bank_card?.balance?.string.originalPrice
    }
    
    static func mock() -> UserBankCardModel {
        let model = UserBankCardModel()
        model.cardName = "elbek's card"
        model.id = 2
        model.bank_card = .mock()
        model.color = "#2c3e50"
        model.status = "secondary"
        return model
    }
}

public class BankCardModel: Codable {
    var id: Int?
    var expiry: String?
    var type: String?
    var full_name: String?
    var pan: String?
    var balance: Double?
    
    
    init(id: Int? = nil, expiry: String? = nil, type: String? = nil, full_name: String? = nil, pan: String? = nil, balance: Double? = nil) {
        self.id = id
        self.expiry = expiry
        self.type = type
        self.full_name = full_name
        self.pan = pan
        self.balance = balance
    }
    
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(Int.self, forKey: .id)
        self.expiry = try container.decodeIfPresent(String.self, forKey: .expiry)
        self.type = try container.decodeIfPresent(String.self, forKey: .type)
        self.full_name = try container.decodeIfPresent(String.self, forKey: .full_name)
        self.pan = try container.decodeIfPresent(String.self, forKey: .pan)
        self.balance = try container.decodeIfPresent(Double.self, forKey: .balance)
    }

    func getSpacedPan() -> String {
        (pan ?? "").format("xxxx xxxx xxxx xxxx", oldString: (pan ?? ""))
    }
    
    func getType() -> BankType {
        guard let type = type,
              let bankType = BankType(rawValue: type) else {
                  return .none
              }
        
        return bankType
    }
    
    static func mock() -> BankCardModel {
        let model = BankCardModel()
        model.expiry = "1225"
        model.id = 2
        model.type = "uzcard"
        model.full_name = "HASANOV ELBEK ELDOR OGLI"
        model.pan = "860031******0575"
        return model
    }
}
