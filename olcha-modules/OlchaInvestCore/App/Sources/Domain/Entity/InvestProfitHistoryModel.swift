//
//  InvestProfitHistoryModel.swift
//  OlchaInvestCore
//
//  Created by Elbek Khasanov on 11/05/24.
//  Copyright © 2024 Olcha. All rights reserved.
//

import UIKit
public struct InvestProfitHistoryData: Codable {
    public var withdrawalRequest: [InvestProfitHistoryModel]?
}
public struct InvestProfitHistoryModel: Codable {
    enum HistoryStatus: Int {
        case confirmed = 1
        case canceled = -1
        case pending = 0
        
        var title: String {
            switch self {
            case .confirmed:
                return "confirmed".localized()
            case .canceled:
                return "canceled".localized()
            case .pending:
                return "pending".localized()
            }
        }
        
        var color: UIColor? {
            switch self {
            case .confirmed:
                return .olchaGreen
            case .canceled:
                return .olchaAccentColor
            case .pending:
                return .olchaYellow
            }
        }
        
        var icon: UIImage? {
            switch self {
            case .confirmed:
                return .historyConfirmed
            case .canceled:
                return .historyCanceled
            case .pending:
                return .historyInfo
            }
        }
    }
    
    var amount: String?
    var state: Int?
    var id: Int?
    var type: String?
    var updated_at: String?
    
    func getDate() -> String {
        return updated_at?.formated_date ?? "-"
    }
    
    func getPrice() -> String {
        return amount?.originalPriceDouble ?? "-"
    }
    
    func getStatus() -> HistoryStatus {
        return HistoryStatus(rawValue: state ?? 0) ?? .pending
    }
}
