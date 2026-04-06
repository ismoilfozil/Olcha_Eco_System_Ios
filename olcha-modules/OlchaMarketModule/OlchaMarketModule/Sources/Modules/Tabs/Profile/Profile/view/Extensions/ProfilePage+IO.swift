//
//  ProfilePage+IO.swift
//  OlchaMarketModule
//
//  Created by ahrorxudja on 20/11/23.
//

import Foundation
import OlchaAuth
import OlchaVerification
import OlchaUtils
import OlchaUI

extension ProfilePage {
    struct Input {
        let userSkeleton = Skeleton()
        let cardSkeleton = Skeleton()
        
        var balance: Balance?
        var bonus: Bonus?
        var user: User?
        var verification: VerificationData?
        var isVerified: Bool {
            AuthGlobalDefaults.user.isVerified ?? false
        }
        var isProgressHidden: Bool {
            AuthGlobalDefaults.user.isVerified ?? true
        }
        
        mutating func reset() {
            balance = nil
            bonus = nil
            user = nil
            verification = nil
        }
    }
    
    struct Output {
        
    }
}
