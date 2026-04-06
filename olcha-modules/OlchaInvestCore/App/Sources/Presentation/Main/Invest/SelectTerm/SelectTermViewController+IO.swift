//
//  SelectTermViewController+IO.swift
//  OlchaInvestCore
//
//  Created by Akhrorkhuja on 26/05/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import OlchaUtils
import OlchaUI

public extension SelectTermViewController {
    
    struct Input {
        var terms = PagingData<InvestmentModel>()
        var termsSkeleton = Skeleton(count: 3)
        
        public init() {}
    }
    
    struct Output {
        var packageId: Int?
        var childPackageId: Int?
        var term: InvestmentModel?
        public init() {}
    }
    
}
