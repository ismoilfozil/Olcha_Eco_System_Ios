//
//  PartnersViewController+IO.swift
//  OlchaNasiyaModule
//
//  Created by Elbek Khasanov on 18/05/23.
//

import UIKit
import OlchaUI
import OlchaUtils
import SkeletonView

extension PartnersViewController {
    public struct Input {
        public init() {}
    }
    
    public struct Output {
        public let timerManager = SearchTimerManager()
        public var filter = PartnerFilter()
        public var skeleton = Skeleton(count: 5)
        public init() {}
    }
}
