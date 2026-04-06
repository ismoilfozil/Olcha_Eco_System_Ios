//
//  ProfieCardsView+IO.swift
//  OlchaInvestCore
//
//  Created by Akhrorkhuja on 18/07/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import OlchaUtils
import OlchaUI
import OlchaBilling

public extension ProfieCardsView {
    struct Input {
        public var balances: [BillingCollectionItem] = []
        public var balancesSkeleton = Skeleton(count: 2)
        
        public init() {}
        
        public mutating func reset() {
            balances.removeAll()
            balancesSkeleton.isAnimating = true
        }
    }
    
    struct Output {
        public var balanceCollectionItem: BillingCollectionItem?
        
        public init() {}
    }
}
