//
//  AuthStorage.swift
//  OlchaAuth
//
//  Created by Elbek Khasanov on 12/04/23.
//

import Foundation
import OlchaUtils
import Combine
@propertyWrapper
public struct AuthDefaults<T> {
    let key: String
    var storage: UserDefaults? = UserDefaults(suiteName: "olcha-auth")
    
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

public final class AuthGlobalDefaults: @unchecked Sendable {
    
    public enum UserType {
        case guest
        case user
    }
    
    nonisolated(unsafe) public static let shared = AuthGlobalDefaults()
    
    public init() { }
    
    nonisolated(unsafe) public static let logoutObserver = PassthroughSubject<Void, Never>()
    nonisolated(unsafe) public static let userTypeChanged = PassthroughSubject<Bool, Never>()
    
    public static var access_token: String? {
        get { UserDefaults(suiteName: "olcha-auth")?.value(forKey: "access_token") as? String }
        set { UserDefaults(suiteName: "olcha-auth")?.set(newValue, forKey: "access_token") }
    }
    
    public static var refresh_token: String? {
        get { UserDefaults(suiteName: "olcha-auth")?.value(forKey: "refresh_token") as? String }
        set { UserDefaults(suiteName: "olcha-auth")?.set(newValue, forKey: "refresh_token") }
    }
    
    public static var client_type: String? {
        get { UserDefaults(suiteName: "olcha-auth")?.value(forKey: "client_type") as? String }
        set { UserDefaults(suiteName: "olcha-auth")?.set(newValue, forKey: "client_type") }
    }
    
    public static var referral_id: String? {
        get { UserDefaults(suiteName: "olcha-auth")?.value(forKey: "referral_id") as? String }
        set { UserDefaults(suiteName: "olcha-auth")?.set(newValue, forKey: "referral_id") }
    }
    
    public static var password: String? {
        get { UserDefaults(suiteName: "olcha-auth")?.value(forKey: "password") as? String }
        set { UserDefaults(suiteName: "olcha-auth")?.set(newValue, forKey: "password") }
    }
    
    public struct user {
        public static var id: Int? {
            get { UserDefaults(suiteName: "olcha-auth")?.value(forKey: "id") as? Int }
            set { UserDefaults(suiteName: "olcha-auth")?.set(newValue, forKey: "id") }
        }
        
        public static var name: String? {
            get { UserDefaults(suiteName: "olcha-auth")?.value(forKey: "name") as? String }
            set { UserDefaults(suiteName: "olcha-auth")?.set(newValue, forKey: "name") }
        }
        
        public static var phone: String? {
            get { UserDefaults(suiteName: "olcha-auth")?.value(forKey: "phone") as? String }
            set { UserDefaults(suiteName: "olcha-auth")?.set(newValue, forKey: "phone") }
        }
        
        public static var created_at: String? {
            get { UserDefaults(suiteName: "olcha-auth")?.value(forKey: "created_at") as? String }
            set { UserDefaults(suiteName: "olcha-auth")?.set(newValue, forKey: "created_at") }
        }
        
        public static var isVerified: Bool? {
            get { UserDefaults(suiteName: "olcha-auth")?.value(forKey: "verifiedCredit") as? Bool }
            set { UserDefaults(suiteName: "olcha-auth")?.set(newValue, forKey: "verifiedCredit") }
        }
        
        public static func restartUser() {
            
            AuthGlobalDefaults.user.id = nil
            AuthGlobalDefaults.user.name = nil
            AuthGlobalDefaults.user.phone = nil
            AuthGlobalDefaults.user.created_at = nil
            AuthGlobalDefaults.user.isVerified = nil
            
        }
    }
    
    public struct notification {
        public static var fcm_token: String? {
            get { UserDefaults(suiteName: "olcha-auth")?.value(forKey: "fcm_token") as? String }
            set { UserDefaults(suiteName: "olcha-auth")?.set(newValue, forKey: "fcm_token") }
        }
    }
    
    public static func getClientType() -> String {
        var type = AuthTexts.client_credentials
        if (AuthGlobalDefaults.client_type ?? "") == AuthTexts.refresh_token {
            type = AuthTexts.refresh_token
        }
        return type
    }
    
    public static func isUser() -> Bool {
//        return true
        return AuthGlobalDefaults.getClientType() == AuthTexts.refresh_token
    }
    
    public static func makeGuest() {
        AuthGlobalDefaults.notification.fcm_token = nil
        AuthGlobalDefaults.user.restartUser()
        AuthGlobalDefaults.access_token = nil
        AuthGlobalDefaults.refresh_token = nil
        AuthGlobalDefaults.password = nil
        AuthGlobalDefaults.changeCredentials(userType: .guest)
    }
    
    public static func getToken() -> String {
//        return "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiI2IiwianRpIjoiOGMxMTkyMTFhOGU4ZmE1NTUwYmU0NWZkZjFmZTg5Y2Q0MDNjNjE2YmQzMTc1YjdkNmUxOWI0MjE3YjNhYjk4YWIxZDYzMTY2OGVlZmI1MDEiLCJpYXQiOjE2ODk4NDY1NDEuODEyMTkwMSwibmJmIjoxNjg5ODQ2NTQxLjgxMjE5MjksImV4cCI6MTY5MjQzODU0MS44MDU1NjcsInN1YiI6IjMzNzkiLCJzY29wZXMiOltdfQ.WaiaJmNHBqqYQJf1b3zWJ0-krBYbxeOFYExyv7eSsnS7bze7TDPfxmNH-58NSZlY8Jj0nmSD2f8J8jFa-Q_8lbBJI1ftU7arQxh2C9zxaaGRd6KuV7aoIYkxpOxh6qh8OaLqEErN3W-FbdRwUoPoe-kDdWByHTpOxUuIa3eijijydQHa7mFKBwQjVcoMklNAPGpL649GDqbECXO7LrsLaiHrRrFHiVGGEg7Qw0cZvzhZ9-ODn1JWYg9x9JnkmlvyNWWKE4sbCgtIB3IVm0fbRCJZMxvQZECHALVbpZ-RvO2BjI0rRP8noLtBBiYyqBQ5m-zUUSSmwTLJHi9Nd27UgmeyswA9XkIZt6C-V7iEJSozSKwN2Cu8Eie3qcHba_cNBT7MKC2vzFT-gUs6nmok4Sx3euWDWleBBAfyJAEz0JSjNzOLZgVuF7Mk_hPFqron24sbi7aQb_Qi28xE2ACFvUyyJxJSOIO_eeEYnWoVjbpvMneVlr6XoO1ObRaqHFmX_4bA8wkckZ7GR4nCQWJORUGYgyLDZyD9UKaE_kz8pIa8QpA9N7K1l2fIChGck9AnO8Zifo2efKMBvaQA-Na-CxdnitfTNMPvXZeLcYzVqrxI4Yj48tCFt0GRCG8b32JrIp5OalXm1zRqHMXAJaXyzxMFLiKKqAcRiqUHFvG0aIk"
        let token: String = AuthGlobalDefaults.access_token ?? ""
        
        if token != "" {
            return "Bearer " + token
        }
        return token
    }
    
    public static func logout() {
        AuthGlobalDefaults.logoutObserver.send()
        AuthGlobalDefaults.makeGuest()
        AuthViewModel.shared.getToken()
    }
    
    public static func changeCredentials(userType: UserType) {

        let oldUserType = AuthGlobalDefaults.client_type
        switch userType {
        case .user:
            AuthGlobalDefaults.client_type = AuthTexts.refresh_token
        case .guest:
            AuthGlobalDefaults.client_type = AuthTexts.client_credentials
        }
        if oldUserType != AuthGlobalDefaults.client_type {
//            userTypeChanged.send(true)
        }
    }
    
}
