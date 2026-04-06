//
//  NotificationManager.swift
//  OlchaInvestCore
//
//  Created by Akhrorkhuja on 22/07/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import UIKit

public enum NotificationAction: String, Codable {
    case addInvest = "ADD_INVEST"
    case contractDetail = "CONTRACT_DETAIL"
    case newsDetail = "NEWS_DETAIL"
    case news = "NEWS"
    case message = "MESSAGE"
    case package = "PACKAGE"
    case showProfile = "SHOW_PROFILE"
    case showBalance = "SHOW_BALANCE"
    case withdraw = "WITHDRAW"
}

public enum NotificationRoute {
    case addInvest
    case contractDetail(contractId: Int)
    case newsDetail(postId: Int)
    case news
    case message(title: String, description: String)
    case package(packageId: Int)
    case showProfile
    case showBalance(balanceId: Int)
    case withdraw(contractId: Int)
}

public final class NotificationManager: NSObject {
    
    public static let `default` = NotificationManager()
    
    public var subscribe: ((String) -> Void)?
    public var unsubscribe: ((String, @escaping (Error?) -> Void) -> Void)?
    
    public func route(from data: CloudNotification) -> NotificationRoute? {
        switch data.click_action {
        case .addInvest:
            return .addInvest
        case .contractDetail:
            guard let contractId = data.contract_id?.int else { return .none }
            return .contractDetail(contractId: contractId)
        case .newsDetail:
            guard let postId = data.post_id?.int else { return .none }
            return .newsDetail(postId: postId)
        case .news:
            return .news
        case .message:
            let title = String.lang(data.message_title_ru, data.message_title_uz, data.message_title_oz)
            let description = String.lang(data.message_description_ru, data.message_description_uz, data.message_description_oz)
            return .message(title: title, description: description)
        case .package:
            guard let packageId = data.package_id?.int else { return .none }
            return .package(packageId: packageId)
        case .showProfile:
            return .showProfile
        case .showBalance:
            guard let balanceId = data.balance_id?.int else { return .none }
            return .showBalance(balanceId: balanceId)
        case .withdraw:
            guard let contractId = data.contract_id?.int else { return .none }
            return .withdraw(contractId: contractId)
        }
    }
    
}
