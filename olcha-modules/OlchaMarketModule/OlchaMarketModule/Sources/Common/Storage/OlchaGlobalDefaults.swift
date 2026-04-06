//
//  StorageService.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 29/06/22.
//

import Foundation
import OlchaVerification
import OlchaAuth
@propertyWrapper
public struct Defaults<T> {
    let key: String
    var storage: UserDefaults? = .standard
    
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

public class OlchaGlobalDefaults {
    public static var shared = OlchaGlobalDefaults()
    private var defaults = UserDefaults.standard
    
    public struct session {
        @Defaults(key: "user_first_time") static var entered: Bool?
    }
    
    public struct user {
        @Defaults(key: "adult_age") static var isAdult: Bool?
        
        @Defaults(key: "pray_times") static var prayNotifications: Bool?
        
        @Defaults(key: "ramazan_pray_times") public static var ramazanPrayNotifications: Bool?
        
        static func restartUser() {
            OlchaGlobalDefaults.user.isAdult = nil
            AuthGlobalDefaults.user.isVerified = nil
        }
    }

    
    @Defaults(key: "cart_key") static var cart_key: String?
    @Defaults(key: "favorite_key") public static var favorite_key: String?
    @Defaults(key: "compare_key") public static var compare_key: String?
    
    @Defaults(key: "notification") public static var notification: Bool?
    @Defaults(key: "fcm_token") public static var fcm_token: String?

    static func isCreditVerified() -> Bool {
        AuthGlobalDefaults.user.isVerified ?? false
    }
    
    public static func logout() {
        AuthGlobalDefaults.makeGuest()
        OlchaGlobalDefaults.user.restartUser()
        AuthViewModel.shared.getToken()
        favorite_key = nil
        cart_key = nil
        compare_key = nil
    }
    
    struct search {
        @Defaults(key: "histories") static var histories: [String]?
        
        static func add(history: String) {
            if OlchaGlobalDefaults.search.histories == nil {
                OlchaGlobalDefaults.search.histories = []
            }
            
            OlchaGlobalDefaults.search.histories = OlchaGlobalDefaults.search.histories?.reversed()
            
            if !(OlchaGlobalDefaults.search.histories?.contains(history) ?? false) {
                OlchaGlobalDefaults.search.histories?.append(history)
            }
            
            if OlchaGlobalDefaults.search.histories?.count == 3 {
                OlchaGlobalDefaults.search.histories?.removeFirst()
            }
            
            OlchaGlobalDefaults.search.histories = OlchaGlobalDefaults.search.histories?.reversed()
        }
        
        static func remove(index: Int) {
            if index < (OlchaGlobalDefaults.search.histories?.count ?? 0) {
                OlchaGlobalDefaults.search.histories?.remove(at: index)
            }
        }
    }
}

