//
//  CloudNotification.swift
//  OlchaInvestCore
//
//  Created by Akhrorkhuja on 23/07/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import Foundation

public struct CloudNotification: Codable {
    public let click_action: NotificationAction
    public let contract_id: String?
    public let post_id: String?
    public let balance_id: String?
    public let package_id: String?
    /// PopUp Message
    public let message_title_ru: String?
    public let message_title_uz: String?
    public let message_title_oz: String?
    public let message_description_ru: String?
    public let message_description_uz: String?
    public let message_description_oz: String?
}
