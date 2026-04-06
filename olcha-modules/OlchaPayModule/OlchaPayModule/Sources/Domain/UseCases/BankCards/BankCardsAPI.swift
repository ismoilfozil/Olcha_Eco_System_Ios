//
//  BankCardsAPI.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 15/03/23.
//

import Foundation
import OlchaCore
public enum BankCardsAPI {
    case bankcards
    case balance
    case transactions
}

extension BankCardsAPI: BaseOlchaPayApi {
    public var path: String {
        switch self {
        case .bankcards:
            return "bankcards/"
        case .balance:
            return "bankcards/balance/"
        case .transactions:
            return "bankcards/transactions/"
        }
    }
    
    public var method: RequestType {
        switch self {
        case .bankcards:
            return .get
        case .balance:
            return .get
        case .transactions:
            return .get
        }
    }
    
    public var body: Data? {
        var data: Data?

        switch self {
            default: break
        }
        
        return data
    }
    
    
}
