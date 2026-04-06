//
//  InvestorContractData.swift
//  OlchaInvestCore
//
//  Created by Akhrorkhuja on 18/05/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import Foundation
import OlchaCore

public struct InvestorContractData: Codable {
    public var paginator: Paginator?
    public var investorsContracts: [InvestorContractModel]
    
    public static func mock(page: Int, lastPage: Int = 3) -> InvestorContractData {
        var paginator = Paginator()
        paginator.current_page = page
        paginator.last_page = lastPage
        
        return InvestorContractData(paginator: paginator, investorsContracts: [
            .mock(id: 1),
            .mock(id: 2),
            .mock(id: 3),
            .mock(id: 4),
        ])
    }
}

public struct InvestorContractModel: Codable {
    public var id: Int?
    public var auto_withdrawal: Bool?
    public var start_invest: Double?
    public var invest_sum: Double?
    public var investment_name: String?
    public var contract_name: String?
    public var percent: Double?
    public var profit: String?
    public var profit_balance: String?
    public var currency: String?
    public var unwrappedCurrency: String {
        currency.unwrap.uppercased()
    }
    public var contract_status: Int?
    public var status: Int?
    public var statusBool: Bool {
        status != 0
    }
    public var status_type: StatusType
    public var term: Int?
    public var billing_reflection: String?
    public var min_invest: Double?
    public var max_invest: Double?
    
    public static func mock(id: Int = 1) -> InvestorContractModel {
        .init(
            id: id,
            start_invest: 10_000,
            investment_name: "Invest Lorem",
            profit: "0",
            contract_status: 1,
            status: 1,
            status_type: .active
        )
    }
    
    func getProfitOut() -> String {
        ((profit?.double ?? 0) - (profit_balance?.double ?? 0)).string
    }
}

public struct ToggleContractStatusRequest: Codable {
    public var status: ContractStatus.RawValue
    public var comment: String
    
    public enum ContractStatus: Int {
        case disable = 0
        case enable = 1
    }
}
