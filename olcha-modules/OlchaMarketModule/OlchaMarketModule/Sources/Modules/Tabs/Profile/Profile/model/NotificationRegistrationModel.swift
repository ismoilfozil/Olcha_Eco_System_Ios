//
//  NotificationRegistrationModel.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 13/01/23.
//
import UIKit
import Foundation
import OlchaAuth
public struct NotificationRegistrationModel: Codable {
    var type: String = "ios"
    var token = AuthGlobalDefaults.notification.fcm_token ?? ""
    var user_id = AuthGlobalDefaults.user.id?.string
    var is_enabled: Bool = true
    var user_lang = String.getAppLanguage()
    var app_version = MarketTexts.app_version
    var device_id: String? = UIDevice.current.identifierForVendor?.uuidString
    var device_lang: String? = Locale.current.languageCode
    var device_model: String? = "\(UIDevice.modelName);" + "ios: \(UIDevice.current.systemVersion)"

    var created_at: String? = AuthGlobalDefaults.user.created_at
    var updated_at: String? = nil
    
    var unique_id: String? = nil
}


struct RamadanNotificationModel: Codable {
    let type: String
    let fcm_token: String = AuthGlobalDefaults.notification.fcm_token ?? ""
    let status: Bool
}
