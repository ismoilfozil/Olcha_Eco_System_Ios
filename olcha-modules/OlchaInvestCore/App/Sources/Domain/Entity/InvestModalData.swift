//
//  InvestModalData.swift
//  OlchaInvestCore
//
//  Created by Akhrorkhuja on 22/05/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import Foundation

public struct InvestModalData {
    public let id: Int
    public let amount: Float
    public let percent: String
    public let term: String
    
    public static func mock(id: Int = 1) -> InvestModalData {
        .init(
            id: Int.random(in: 1...100),
            amount: Float.random(in: 1000...1000000),
            percent: "\(Int.random(in: 1...100)) %",
            term: "\(Int.random(in: 1...12)) мес"
        )
    }
}
