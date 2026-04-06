//
//  NotificationAction.swift
//  OlchaNasiyaModule
//
//  Created by Akhrorkhuja on 08/08/23.
//

import Foundation

public enum NotificationAction: String, Codable {
    case limitCard = "LIMIT_CARD"
    case installment = "INSTALLMENT"
    case payInstallment = "PAY_INSTALLMENT"
    case verification = "VERIFICATION"
}
