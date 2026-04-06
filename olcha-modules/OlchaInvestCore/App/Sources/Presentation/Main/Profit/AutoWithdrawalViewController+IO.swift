//
//  AutoWithdrawalViewController+IO.swift
//  OlchaInvestCore
//
//  Created by Akhrorkhuja on 01/06/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import Foundation
import OlchaBilling
import OlchaUtils
import OlchaUI

public extension AutoWithdrawalViewController {
    struct Input {
        var parentCards : [BillingCollectionItem] = []
        var cardsSkeleton = Skeleton(count: 3)
        var autoWithdrawalData: AutoWithdrawalModel?
    
        public init() {}
    }
    
    struct Output {
        var selectedCardId: Int?
        var selectedCardAlias: String?
        var selectedCard: IndexPath?
        
        public init() {}
    }
}
