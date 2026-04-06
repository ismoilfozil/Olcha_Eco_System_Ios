//
//  BalancesData.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 24/10/22.
//

import Foundation
import OlchaUtils
public struct BalancesData: Codable {
    public var platformBalance: Balance?
    public var instalmentBalance: Balance?
    public var balances: [Balance]?
    
    public init(platformBalance: Balance? = nil,
                balances: [Balance]? = nil) {
        self.platformBalance = platformBalance
        self.balances = balances
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        do {
            self.platformBalance = try container.decodeIfPresent(Balance.self, forKey: .platformBalance)
        } catch {}
        do {
            self.balances = try container.decodeIfPresent([Balance].self, forKey: .balances)
        } catch {}
        do {
            self.instalmentBalance = try container.decodeIfPresent(Balance.self, forKey: .instalmentBalance)
        } catch {}
    }
}


