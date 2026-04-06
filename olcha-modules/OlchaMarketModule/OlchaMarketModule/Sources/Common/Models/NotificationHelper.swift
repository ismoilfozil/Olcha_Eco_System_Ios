//
//  ImageHelper.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 24/06/22.
//

import UIKit

enum Language: String {
    static let notification_key = "notificationLanguage"
    case oz
    case ru
    
    var localization_key: String {
        switch self {
        case .oz:
            return "en"
        case .ru:
            return "ru"
        }
    }
    
}

class NotificationHelper {
    
    
    static func setLangToNotification(_ lang: Language) {
        let userDefaults = UserDefaults(suiteName: "group.com.olcha.ecommerce")
        userDefaults?.set(lang.rawValue, forKey: Language.notification_key)
        userDefaults?.synchronize()
    }
    
    static func setRamazanPrayNotification(_ isActive: Bool) {
        let userDefaults = UserDefaults(suiteName: "group.com.olcha.ecommerce")
        userDefaults?.set(isActive, forKey: "ramazan_pray_times")
        userDefaults?.synchronize()
    }
    
    
}
