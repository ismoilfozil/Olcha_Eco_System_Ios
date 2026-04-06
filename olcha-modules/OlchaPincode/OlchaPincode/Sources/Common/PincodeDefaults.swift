//
//  PincodeDefaults.swift
//  OlchaPincode
//
//  Created by Elbek Khasanov on 19/05/23.
//

import Foundation
@propertyWrapper
public struct PincodeDefaults<T> {
    let key: String
    var storage: UserDefaults? = UserDefaults(suiteName: "olcha-pincode")
    
    public var wrappedValue: T? {
        get {
            let v = storage?.value(forKey: key) as? T
            return v
        }
        set {
            storage?.set(newValue, forKey: key)
        }
    }

}
public final class PincodeGlobalDefaults: @unchecked Sendable {
    public static let shared = PincodeGlobalDefaults()
    
    public init() { }
    
    public struct session {
        public static var pincode: String? {
            get { UserDefaults(suiteName: "olcha-pincode")?.value(forKey: "pincode") as? String }
            set { UserDefaults(suiteName: "olcha-pincode")?.set(newValue, forKey: "pincode") }
        }
        
        public static func isInitialPincode() -> Bool {
            (pincode?.isEmpty ?? true)
        }
        
        public static func logout() {
            pincode = nil
        }
    }
    public struct settings {
        public static var biometricEnabled: Bool? {
            get { UserDefaults(suiteName: "olcha-pincode")?.value(forKey: "biometric") as? Bool }
            set { UserDefaults(suiteName: "olcha-pincode")?.set(newValue, forKey: "biometric") }
        }
    }
}
