//
//  CloudNotification.swift
//  OlchaNasiyaModule
//
//  Created by Akhrorkhuja on 08/08/23.
//

import Foundation

public struct CloudNotification: Codable {
    public let click_action: NotificationAction
    public let installment_id: String?
}

