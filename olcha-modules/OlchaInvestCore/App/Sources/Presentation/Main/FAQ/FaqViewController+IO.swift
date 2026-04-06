//
//  FaqViewController+IO.swift
//  OlchaInvestCore
//
//  Created by ahrorxudja on 24/10/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import OlchaUI
import OlchaCommon

public extension FaqViewController {
    struct Input {
        public var faqs: [CommonFAQModel] = []
        public var faqsSkeleton = Skeleton(count: 10)
        
        public init() {}
        
        public mutating func reset() {
            faqs.removeAll()
        }
    }
    
    struct Output {
        public init() {}
    }
}
