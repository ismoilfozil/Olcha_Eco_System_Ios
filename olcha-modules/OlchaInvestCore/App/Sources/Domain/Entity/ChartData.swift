//
//  ChartData.swift
//  OlchaInvestCore
//
//  Created by Akhrorkhuja on 14/06/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import Foundation

public struct ContractChartData: Codable {
    public var chart_items: [ContractChartModel]
    
    enum CodingKeys: String, CodingKey {
        case chart_items = "chart-items"
    }
}

public struct ContractChartModel: Codable {
    public var date: String?
    public var invest_sum: Double?
    public var returned_invest: Double?
    public var debit_sum: Double?
}
