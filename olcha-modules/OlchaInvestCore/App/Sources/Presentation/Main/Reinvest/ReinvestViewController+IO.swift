//
//  ReinvestViewController+IO.swift
//  OlchaInvestCore
//
//  Created by Akhrorkhuja on 22/06/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import OlchaUtils

public extension ReinvestViewController {
    struct Input {
        var cards = PagingData<CardModel>()
    
        public init() {}
    }
    
    struct Output {
        var selectedCardRowId: Int?
        
        public init() {}
    }
}
