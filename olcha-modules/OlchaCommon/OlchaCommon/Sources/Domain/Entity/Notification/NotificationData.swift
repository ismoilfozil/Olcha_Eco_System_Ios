//
//  NotificationData.swift
//  OlchaNasiyaModule
//
//  Created by Elbek Khasanov on 12/05/23.
//

import UIKit
import OlchaCore
import OlchaUtils

public struct CommonNotificationData: Codable {
    public var paginator: Paginator?
    public var notifications: [CommonNotificationModel]?
    public var groups: [String: String]?
}

public struct CommonNotificationModel: Codable {
    public var id: Int?
    public var group: String?
    public var icon: String?
    public var click_action: CommonNotificationClickAction?
    public var content: String?
    public var images: [String]?
    public var image: String?
    public var icon_color: String?
    public var icon_text: String?
    public var title: String?
    public var template: String?
    public var date: String?
    public var status: String?
    public var status_color: String?
    public var status_icon: String?
    public var installment_percent: Double?
    public var price: Double?
    
    public func getPercentage() -> String {
        "\(Float(installment_percent ?? 0).string.originalPriceWithoutCurrency)%"
    }
}

public extension CommonNotificationModel {
    enum NotificationTemplate: String {
        case order
        case installment
    }
    
    func getTemplate() -> NotificationTemplate? {
        .init(rawValue: template ?? "")
    }
}

public struct CommonNotificationClickAction: Codable {
    public var module: String?
    public var click_action: String?
    public var click_action_id: String?
    
    public func getAction() -> ClickAction? {
        let action = click_action ?? ""
        let id = click_action_id?.int
        
        if let action = NasiyaClickAction.fromRawValue(action, actionId: id) {
            return action
        } else if let action = InvestClickAction.fromRawValue(action, actionId: id) {
            return action
        } else if let action = MarketClickAction.fromRawValue(action, actionId: id) {
            return action
        } else if let action = PayClickAction.fromRawValue(action, actionId: id) {
            return action
        } else if let action = CommonClickAction.fromRawValue(action, actionId: id) {
            return action
        }
        
        return nil
    }
}
