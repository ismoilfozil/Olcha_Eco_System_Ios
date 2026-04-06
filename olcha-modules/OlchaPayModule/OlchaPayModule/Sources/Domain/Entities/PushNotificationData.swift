//
//  PushNotificationData.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 11/04/23.
//

import Foundation
import OlchaUtils
public struct PushNotificationData: Codable {
    var name_uz: String?
    var name_ru: String?
    
    var body_ru: String?
    var body_uz: String?
    
    var icon: String?
    
    var provider_id: Int?
    var service_id: Int?
    
    var action: String?
    
    var fields: [TransactionKeyValueModel]?
    
    func getName() -> String {
        .lang(name_ru, name_uz, name_uz)
    }
    
    func getBody() -> String {
        .lang(body_ru, body_uz, body_uz)
    }
    
    func getNotificationType() -> NotificationAction {
        guard let action = action,
              let typeAction = NotificationAction(rawValue: action) else { return .none }
        return typeAction
    }
}
