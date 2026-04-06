//
//  InvestHomeViewController+IO.swift
//  OlchaInvestCore
//
//  Created by Akhrorkhuja on 18/05/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import OlchaUtils
import OlchaUI

public extension InvestHomeViewController {
    
    struct Input {
        public var invests = PagingData<InvestorContractModel>()
        public var investsSkeleton = Skeleton(count: 3)
    
        public init() {}
        
        public mutating func reset() {
            invests.reset()
            investsSkeleton.isAnimating = true
        }
    }
    
    struct Output {
        public init() {}
    }
    
}
