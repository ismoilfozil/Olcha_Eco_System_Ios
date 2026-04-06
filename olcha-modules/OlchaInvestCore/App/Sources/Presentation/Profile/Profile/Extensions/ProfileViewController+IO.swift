//
//  NasiyaHomeViewController+IO.swift
//  OlchaNasiyaModule
//
//  Created by Elbek Khasanov on 11/05/23.
//

import Foundation
import Combine
import OlchaCore
import OlchaUI
import OlchaUtils
import OlchaAuth
import UIKit

public extension ProfileViewController {
    
    struct Input {
        public var balance: Balance?
        public var user: User?
        public var skeletonViews: [UIView] = []
        
        public init() {}
        
        public mutating func reset() {
            balance = nil
            user = nil
        }
    }
    
    struct Output {
        public let balanceFilled = PassthroughSubject<Void, Never>()
        
        public init() {}
    }
    
}
