//
//  SelectPackageViewController+IO.swift
//  OlchaInvestCore
//
//  Created by Akhrorkhuja on 25/05/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import OlchaUtils
import OlchaUI

public extension SelectPackageViewController {
    
    struct Input {
        var packages = PagingData<InvestmentModel>()
        var packagesSkeleton = Skeleton(count: 3)
        
        public init() {}
    }
    
    struct Output {
        public init() {}
    }
    
}
