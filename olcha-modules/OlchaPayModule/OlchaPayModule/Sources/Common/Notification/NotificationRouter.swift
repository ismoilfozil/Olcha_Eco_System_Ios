//
//  NotificationRouter.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 11/04/23.
//

import Foundation

enum NotificationAction: String {
    case payment
    case none
}

enum NotificationType {
    case payment(helper: MakePaymentHelper)
    case none
}

class NotificationRouter {
    static func checkNotificationType(data: PushNotificationData) -> NotificationType {
        switch data.getNotificationType() {
        case .payment:
            return .payment(
                helper: .init()
                        .addService(data.service_id)
                        .addProvider(data.provider_id)
                        .addFilledFields(data.fields)
            )
            
        case .none:
            return .none
        }
    }
}
