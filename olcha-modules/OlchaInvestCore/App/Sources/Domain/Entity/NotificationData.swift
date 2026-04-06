//
//  NotificationData.swift
//  OlchaInvestCore
//
//  Created by Akhrorkhuja on 17/05/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import UIKit
import OlchaCore

public struct InvestNotificationData: Codable {
    var paginator: Paginator?
    var notifications: [InvestNotificationModel]?
    
    public static func mock(page: Int, lastPage: Int = 3) -> InvestNotificationData {
        var paginator = Paginator()
        paginator.current_page = page
        paginator.last_page = lastPage
        
        return InvestNotificationData(
            paginator: paginator,
            notifications: [
                .mock(1),
                .mock(2),
                .mock(3),
                .mock(4),
                .mock(5),
                .mock(6)
            ])
    }
}

public struct InvestNotificationModel: Codable {
    var id: Int?
    
    var title: String?
    var title_ru: String?
    var title_uz: String?
    var title_oz: String?
    
    var content: String?
    var content_ru: String?
    var content_uz: String?
    var content_oz: String?
    
    var date: String?
    var action: String?
    var status: String?
    
    
    
    public func getTitle() -> String {
        if let title {
            return title
        } else {
            return .lang(title_ru, title_uz, title_oz)
        }
    }
    
    public func getContent() -> String {
        if let content {
            return content
        } else {
            return .lang(content_ru, content_uz, content_oz)
        }
    }
    
    public func getStatus() -> InvestNotificationStatus {
        if let status {
            return InvestNotificationStatus(rawValue: status) ?? .none
        }
        return .none
    }
    
    public func getAction() -> InvestNotificationAction {
        if let status {
            return InvestNotificationAction(rawValue: status) ?? .none
        }
        return .none
    }
    
    public func getDate() -> String {
        if let date {
            return date.formatDate(
                (input: "", output: "YYYY.mm.DD | HH:SS")
            )
        }
        return " - "
    }
    
    public static func mock(_ id: Int? = 1) -> InvestNotificationModel {
        return InvestNotificationModel(
            id: id,
            title_ru: "Добро пожаловать в Olcha Invest!",
            title_uz: "Добро пожаловать в Olcha Invest!",
            title_oz: "Добро пожаловать в Olcha Invest!",
            content_ru: "Система рассрочки Olcha Invest нет никаких скрытых платежей, штрафов и пени. Совершая покупки, вы всегда точно знаете когда закончите платить, кроме этого, высококачественное обслуживание наших клиентов сделает процесс покупки еще быстрее и приятнее.",
            content_uz: "Система рассрочки Olcha Invest нет никаких скрытых платежей, штрафов и пени. Совершая покупки, вы всегда точно знаете когда закончите платить, кроме этого, высококачественное обслуживание наших клиентов сделает процесс покупки еще быстрее и приятнее.",
            content_oz: "Система рассрочки Olcha Invest нет никаких скрытых платежей, штрафов и пени. Совершая покупки, вы всегда точно знаете когда закончите платить, кроме этого, высококачественное обслуживание наших клиентов сделает процесс покупки еще быстрее и приятнее.",
            date: "2020.01.27 | 07:45",
            action: "register",
            status: "initial"
        )
    }
}

public enum InvestNotificationStatus: String {
    case initial = "initial"
    case none
    
    var title: String {
        switch self {
        case .initial:
            return "Поздравления"
        default:
            return " - "
        }
    }
    
    var icon: UIImage? {
        switch self {
        case .initial:
            return .add
        case .none:
            return nil
        }
    }
}

public enum InvestNotificationAction: String {
    case register = "register"
    case none
    
    var title: String {
        switch self {
        case .register:
            return "Пройти регистрацию"
        default:
            return " - "
        }
    }
}
