//
//  KeyValueModel.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 30/03/23.
//

import Foundation
public class TransactionKeyValueModel: Codable {
    public var key: String?
    public var value: String?
    public var is_money: Bool?
    public var type: String?
    
    public init(key: String?, value: String?, is_money: Bool?, type: String?) {
        self.key = key
        self.value = value
        self.is_money = is_money
        self.type = type
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        do {
            self.key = try container.decodeIfPresent(String.self, forKey: .key)
        } catch {}
        do {
            self.value = try container.decodeIfPresent(String.self, forKey: .value)
        } catch {
            let oldValue = try container.decodeIfPresent(Int.self, forKey: .value)
            self.value = oldValue?.string
        }
        self.is_money = try container.decodeIfPresent(Bool.self, forKey: .is_money)
        self.type = try container.decodeIfPresent(String.self, forKey: .type)
    }
}

public struct KeyValueModel: Codable {
    public var key: String?
    public var value: String?
    
    public init(key: String?, value: String?) {
        self.key = key
        self.value = value
    }
}


