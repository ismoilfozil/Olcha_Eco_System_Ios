//
//  NasiyaGlobalDefaults.swift
//  OlchaNasiyaModule
//
//  Created by Elbek Khasanov on 10/05/23.
//

import Foundation
import OlchaUtils
@propertyWrapper
public struct NasiyaDefaults<T> {
    let key: String
    var storage: UserDefaults? = UserDefaults(suiteName: "olcha-nasiya")
    
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
public class NasiyaGlobalDefaults {
    public static let shared = NasiyaGlobalDefaults()
    
    public init() { }
    
    public struct settings {
        @NasiyaDefaults(key: "biometric") public static var biometricEnabled: Bool?
        @NasiyaDefaults(key: "push_notifications") public static var pushNotificationsEnabled: Bool?
    }
    
    public struct cache {

        
    }
    
    
}
