//
//  InvestorApi.swift
//  OlchaInvestCore
//
//  Created by Akhrorkhuja on 27/05/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import Foundation
import OlchaCore

public enum InvestorApi {
    case contracts(page: Int)
    case addContract(model: AddContractRequest)
    case account
    case contract(id: Int)
    case contractHistory(id: Int)
    case contractChart(id: Int)
    case toggleContractStatus(id: Int, model: ToggleContractStatusRequest)
    case deleteContract(id: Int)
    case withdrawHistory(id: Int)
}

extension InvestorApi: InvestBaseApi {
    public var path: String {
        switch self {
        case .contracts, .addContract:
            return "investors-contracts"
        case .account:
            return "investors/auth-account"
        case .contract(let id):
            return "investors-contracts/contract_detail/\(id)"
        case .contractHistory(let id):
            return "investors-contracts/transaction-history/\(id)"
        case .contractChart:
            return "investors-contracts/investments-chart-data"
        case .toggleContractStatus(let id, _):
            return "investors-contracts/toggle-status/\(id)"
        case .deleteContract(let id):
            return "investors-contracts/cancel/\(id)"
        case .withdrawHistory(let id):
            return "investors-withdrawal-requests/withdrawal-request/\(id)"
        }
    }
    
    public var queryItems: [URLQueryItem] {
        switch self {
        case .contracts(let page):
            return [
                .init(name: "page", value: page.string)
            ]
        case .contractChart(let id):
            return [
                .init(name: "platform_type", value: "ios"),
                .init(name: "investor_contract_id", value: id.string)
            ]
        default:
            return []
        }
    }
    
    public var method: RequestType {
        switch self {
        case .addContract:
            return .post
        case .toggleContractStatus:
            return .put
        default:
            return .get
        }
    }
    
    public var body: Data? {
        switch self {
        case .addContract(let model):
            return try? JSONEncoder().encode(model)
        case .toggleContractStatus(_, let model):
            return try? JSONEncoder().encode(model)
        default:
            return nil
        }
    }
}
