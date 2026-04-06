//
//  GlobalDefaults.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 14/02/23.
//

import Foundation
import OlchaUtils
@propertyWrapper
public struct PayDefaults<T> {
    let key: String
    var storage: UserDefaults? = UserDefaults(suiteName: "olcha-pay")
    
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
public class PayGlobalDefaults {
    public static let shared = PayGlobalDefaults()
    
    public init() { }
    
    public struct session {
        @PayDefaults(key: "isEntered") static var isEntered: Bool?
    }
    
    public struct settings {
        @PayDefaults(key: "push_notifications") public static var pushNotificationsEnabled: Bool?
    }
    
    public struct cache {
        
        struct phoneCodes {
            @PayDefaults(key: "phone_codes") public static var data: Data?
            @PayDefaults(key: "phone_codes_update") public static var updated: Date?
            
            static func cachedPhoneCodes() -> PhoneCodesData? {
                guard let data = data,
                      let updated = updated
                else {
                    updated = Date()
                    return nil
                }
                
                let dateComponent = DateComponents(day: 7)
                let currentDate = Date()
                if let oneWeekLaterDate = Calendar.current.date(byAdding: dateComponent,
                                                                to: updated),
                   currentDate > oneWeekLaterDate {
                    return nil
                }
                do {
                    return try JSONDecoder().decode(PhoneCodesData.self, from: data)
                } catch {
                    return nil
                }
            }
            
            static func cachePhoneCode(_ phoneCodesData: PhoneCodesData?) {
                guard let phoneCodesData = phoneCodesData else { return }
                do {
                    self.data = try JSONEncoder().encode(phoneCodesData)
                } catch {}
            }
        }
        
    }
    
    
}
