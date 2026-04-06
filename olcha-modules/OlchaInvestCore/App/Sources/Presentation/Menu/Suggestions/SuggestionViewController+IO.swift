//
//  SuggestionViewController+IO.swift
//  OlchaInvestCore
//
//  Created by Akhrorkhuja on 27/06/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import OlchaUtils
import OlchaUI

public extension SuggestionViewController {
    struct Input {
        var suggestions = PagingData<SuggestionSectionModel>()
        var suggestionsSkeleton = Skeleton(count: 3)
        
        var sectionsCount: Int {
            suggestions.models.count
        }
        
        var sections: [SuggestionSectionModel] {
            suggestions.models
        }
        
        public init() {}
        
        public mutating func reset() {
            suggestions.reset()
            suggestionsSkeleton.isAnimating = true
        }
    }
    struct Output {
        
        public init() {}
    }
}
