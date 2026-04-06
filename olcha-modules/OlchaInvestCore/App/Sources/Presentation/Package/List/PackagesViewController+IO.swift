//
//  PackagesViewController+IO.swift
//  OlchaInvestCore
//
//  Created by Akhrorkhuja on 24/05/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import OlchaUtils
import OlchaUI

public extension PackagesViewController {
    
    struct Input {
        public var packages = PagingData<InvestmentModel>()
        public var packagesSkeleton = Skeleton(count: 3)
        
        public init() {}
        
        public mutating func reset() {
            packages.reset()
            packagesSkeleton.isAnimating = true
        }
    }
    
    struct Output {
        public init() {}
    }
    
}
