//
//  NotificationModel.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 15/02/23.
//

import Foundation
import OlchaCore

public struct NotificationData: Codable {
    var notifications: [NotificationModel]?
    var paginator: Paginator?
}

public class NotificationModel: Codable {
    var id: Int?
    var type: String?
    var title: String?
    var date: String?
    var content: String?
    var isRead: Bool?
}


