//
//  InvestDetailRow.swift
//  OlchaInvestCore
//
//  Created by Akhrorkhuja on 19/05/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import UIKit

public enum InvestDetailRow: TableRowProtocol {
    case topUp
    case withdrawal
    case history
    case stats
    
    public var icon: UIImage? {
        switch self {
        case .topUp: return .plustCircle
        case .withdrawal: return .cornerDownRightAlt
        case .history: return .history
        case .stats: return .graphBar
        }
    }
    
    public var title: String {
        switch self {
        case .topUp: return "invest_modal_fill".localized(.olchaInvestCore)
        case .withdrawal: return "invest_modal_withdraw".localized(.olchaInvestCore)
        case .history: return "invest_modal_history".localized(.olchaInvestCore)
        case .stats: return "invest_modal_statistics".localized(.olchaInvestCore)
        }
    }
}
