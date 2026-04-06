//
//  ContractViewController+IO.swift
//  OlchaInvestCore
//
//  Created by Akhrorkhuja on 14/06/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import UIKit
import OlchaUtils
import OlchaUI

public extension ContractViewController {
    struct Input {
        var history = PagingData<ContractHistoryModel>()
        var chart = PagingData<ContractChartModel>()
        var skeletonViews: [UIView] = []
        var historySkeleton = Skeleton(count: 3)
    
        public init() {}
        
        public mutating func reset() {
            history.reset()
            chart.reset()
        }
    }
    
    struct Output {
        var currency: String?
        
        public init() {}
    }
}
