//
//  Defaults.swift
//  OlchaUtils
//
//  Created by Elbek Khasanov on 14/02/23.
//

import Foundation
@propertyWrapper
struct Defaults<T> {
    let key: String
    var storage: UserDefaults = .standard
    
    var wrappedValue: T? {
        get {
            let v = storage.value(forKey: key) as? T
#if DEBUG
//            Print.msg("GET: '\(key)' = \(String(describing: v)) Type: \(T.self)", details: (#file, #function, #line))
#endif
            return v
        }
        set {
            storage.set(newValue, forKey: key)
#if DEBUG
//            Print.msg("SET: '\(key)' = \(String(describing: newValue)) Type: \(T.self)", details: (#file, #function, #line))
#endif
        }
    }

}
