//
//  NasiyaProfileViewController+IO.swift
//  OlchaNasiyaModule
//
//  Created by Elbek Khasanov on 20/07/23.
//

import Foundation
import OlchaUI
import OlchaAuth
import OlchaVerification

extension NasiyaProfileViewController {
    public struct Input {
        public let userSkeleton = Skeleton()
        public var user: User?
        public var verification: VerificationData?
        
        public init() {}
        
        public mutating func reset() {
            userSkeleton.isAnimating = true
            user = nil
            verification = nil
        }
    }
    
    public struct Output {
        
    }
}
