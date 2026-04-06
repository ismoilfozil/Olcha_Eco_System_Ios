//
//  NotificationDefaults.swift
//  NotificationExtensionService
//
//  Created by Elbek Khasanov on 18/03/23.
//

import Foundation
class NotificationDefaults {
    private let userDefaults = UserDefaults(suiteName: "group.com.olcha.ecommerce")
    
    nonisolated(unsafe) static let shared = NotificationDefaults()
    
    func getLanguage() -> String {
        return userDefaults?.string(forKey: "notificationLanguage") ?? "uz"
    }
    
    func getRamazanState() -> Bool {
        userDefaults?.bool(forKey: "ramazan_pray_times") ?? true
    }
}
