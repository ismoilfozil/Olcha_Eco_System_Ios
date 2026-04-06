//
//  InvestmentData.swift
//  OlchaInvestCore
//
//  Created by Akhrorkhuja on 24/05/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import Foundation
import OlchaCore

public struct InvestmentData: Codable {
    public var paginator: Paginator?
    public var investments: [InvestmentModel]
    
    public static func mock(page: Int, lastPage: Int = 3) -> InvestmentData {
        var paginator = Paginator()
        paginator.current_page = page
        paginator.last_page = lastPage
        
        return InvestmentData(paginator: paginator, investments: [
            .mock(id: 1),
            .mock(id: 2),
            .mock(id: 3),
        ])
    }
}

public struct InvestmentModel: Codable {
    public let id: Int?
    
    public let name: String?
//    public let risk: Int?
    public let percent: Int?
//    public let agreement_condition: Int?
    
//    public let replenishable: Bool
//    public let withdrawable: Bool
    public let parent_id: Int?
    public let lowest_term: Int?
    public let currency: String?
    public var unwrappedCurrency: String {
        currency.unwrap.uppercased()
    }
    public let term: Int?
    public let term_info: String?
    public let minimum_amount: Double?
    
    public let description: String?
    public let additional_info: String?
    public var min_invest: Double?
    public var max_invest: Double?
    
    public init(id: Int? = nil, name: String? = nil, percent: Int? = nil, parent_id: Int? = nil, lowest_term: Int? = nil, currency: String? = nil, term: Int? = nil, minimum_amount: Double? = nil, description: String? = nil, additional_info: String? = nil, term_info: String? = nil) {
        self.id = id
        self.name = name
        self.percent = percent
        self.parent_id = parent_id
        self.lowest_term = lowest_term
        self.currency = currency
        self.term = term
        self.minimum_amount = minimum_amount
        self.description = description
        self.additional_info = additional_info
        self.term_info = term_info
    }
    
    public static func mock(id: Int = 1) -> InvestmentModel {
        .init(id: id,
              name: "Name ru",
              percent: Int.random(in: 1...100),
              currency: "uzs",
              term: Int.random(in: 1...12),
              minimum_amount: Double.random(in: 100_000...10_000_000),
              description: "Description ru Lorem Lorem Lorem Lorem Lorem Lorem Lorem Lorem Lorem Lorem Lorem Lorem Lorem Lorem Lorem",
              additional_info: "RU Description Lorem Lorem Lorem Lorem Lorem Lorem Lorem Lorem Lorem Lorem Lorem Lorem Lorem Lorem Lorem"
        )
    }
}
