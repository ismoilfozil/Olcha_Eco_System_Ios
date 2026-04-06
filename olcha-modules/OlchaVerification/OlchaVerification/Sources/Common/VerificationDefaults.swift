//
//  VerificationDefaults.swift
//  OlchaVerification
//
//  Created by Elbek Khasanov on 21/05/23.
//

import Foundation
import OlchaUtils
@propertyWrapper
public struct VerificationDefaults<T> {
    let key: String
    var storage: UserDefaults? = UserDefaults(suiteName: "olcha-verification")
    
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

@propertyWrapper
public struct CodableVerificationDefaults<T: Codable> {
    let key: String
    var storage: UserDefaults? = UserDefaults(suiteName: "codable-olcha-verification")
    
    public var wrappedValue: T? {
        get {
            guard let data = storage?.data(forKey: key) else { return nil }
            return try? JSONDecoder().decode(T.self, from: data)
        }
        set {
            guard let value = newValue else {
                storage?.removeObject(forKey: key)
                return
            }
            let data = try? JSONEncoder().encode(value)
            storage?.set(data, forKey: key)
        }
    }

}
public class VerificationGlobalDefaults {
    public static let shared = VerificationGlobalDefaults()
    
    public init() { }
    
    public struct settings {
        @VerificationDefaults(key: "requested_time") public static var requested_time: Double?
        
        @CodableVerificationDefaults(key: "verification_statuses") public static var verification_statuses: Dictionary<Int, String>?
        
        public static func getVerification(userId: Int?) -> String? {
            guard let userId else { return nil }
            return verification_statuses?[userId]
        }
        public static func setVerificationStatus(userId: Int?, status: String?) {
            guard let userId else {
                return
            }
            
            if verification_statuses == nil {
                verification_statuses = Dictionary()
            }
            
            verification_statuses?[userId] = status
        }
        
        public static func getVerificationType(userId: Int?) -> VerificationStatusType? {
            guard let userId else { return nil }
            guard let status = verification_statuses?[userId] else { return nil }
            return verification_status_type(verification_status: status)
        }
        
        public static func getRestTime(interval: TimeInterval) -> Int {
            guard let requested_time else { return 0 }
            var requestedTime = Date(timeIntervalSince1970: requested_time)
            requestedTime.addTimeInterval(interval)
            let rest = requestedTime.timeIntervalSince(Date())
            return rest.int
        }
        
        public static func logout() {
            requested_time = nil
        }
        
        
        private static func verification_status_type(verification_status: String?) -> VerificationStatusType? {
            .init(rawValue: verification_status ?? "")
        }
    }
    
//    public struct user {
//        @VerificationDefaults(key: "is_verified") public static var isVerified: Bool?
//
//
//    }
    
}
