//
//  ProfitApi.swift
//  OlchaInvestCore
//
//  Created by Akhrorkhuja on 08/06/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import Foundation
import OlchaCore

public enum ProfitApi {
    case withdrawalRequest(withdrawal: WithdrawalRequest)
    case autoWithdrawal(contractId: Int)
    case toggleAutoWithdrawalStatus(contractId: Int)
    case storeAutoWithdrawal(autoWithdrawal: AutoWithdrawalRequest)
}

extension ProfitApi: InvestBaseApi {
    public var path: String {
        switch self {
        case .withdrawalRequest:
            return "investors-withdrawal-requests"
        case .autoWithdrawal(let contractId):
            return "investors-withdrawal-requests/auth-withdrawal/\(contractId)"
        case .toggleAutoWithdrawalStatus(let contractId):
            return "investors-withdrawal-requests/auth-withdrawal/switch/\(contractId)"
        case .storeAutoWithdrawal:
            return "investors-withdrawal-requests/auth-withdrawal"
        }
    }
    
    public var queryItems: [URLQueryItem] {
        return []
    }
    
    public var method: RequestType {
        switch self {
        case .withdrawalRequest, .storeAutoWithdrawal:
            return .post
        case .autoWithdrawal:
            return .get
        case .toggleAutoWithdrawalStatus:
            return .put
        }
    }
    
    public var body: Data? {
        switch self {
        case .withdrawalRequest(let withdrawal):
            return try? JSONEncoder().encode(withdrawal)
        case .storeAutoWithdrawal(let autoWithdrawal):
            return try? JSONEncoder().encode(autoWithdrawal)
        default:
            return nil
        }
    }
}
