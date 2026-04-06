//
//  MyInstallmentsViewController+IO.swift
//  OlchaNasiyaModule
//
//  Created by Elbek Khasanov on 15/05/23.
//

import UIKit
import Combine
import OlchaCore
import OlchaUI
import OlchaUtils
public extension MyInstallmentsViewController {
    
    struct Input {
        public let skeleton = Skeleton(count: 3)
        public init() {}
    }
    
    struct Output {
        public var filters = InstallmentFilter(status: .all)
        public init() {}
    }
    
}
