//
//  InvestGlobalDefaults.swift
//  OlchaInvestModule
//
//  Created by Akhrorkhuja on 15/05/23.
//

import Foundation
import OlchaUtils

@propertyWrapper
public struct InvestDefaults<T> {
    let key: String
    var storage: UserDefaults? = UserDefaults(suiteName: "olcha-invest")
    
    public var wrappedValue: T? {
        get {
            let v = storage?.value(forKey: key) as? T
#if DEBUG
//            Print.msg("GET: '\(key)' = \(String(describing: v)) Type: \(T.self)", details: (#file, #function, #line))
#endif
            return v
        }
        set {
            storage?.set(newValue, forKey: key)
#if DEBUG
//            Print.msg("SET: '\(key)' = \(String(describing: newValue)) Type: \(T.self)", details: (#file, #function, #line))
#endif
        }
    }
}

public class InvestGlobalDefaults {
    public static let shared = InvestGlobalDefaults()
    
    private init() { }
    
    public struct session {
        @InvestDefaults<String?>(key: "pincode") public static var pincode
    }
    
    public struct settings {
        @InvestDefaults<Bool>(key: "biometric") public static var biometricEnabled
        @InvestDefaults<Bool>(key: "push_notifications") public static var pushNotificationsEnabled
        @InvestDefaults<Bool>(key: "messages_notification") public static var messagesNotificationDisabled
        
        public static var isMessagesNotificationDisabled: Bool {
            messagesNotificationDisabled.orFalse
        }
    }
    
    public struct account {
        @InvestDefaults<Int>(key: "investor_id") public static var investorId
    }
}
