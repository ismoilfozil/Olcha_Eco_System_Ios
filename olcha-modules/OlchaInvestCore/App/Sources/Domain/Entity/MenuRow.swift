//
//  MenuRow.swift
//  OlchaInvestCore
//
//  Created by Akhrorkhuja on 30/05/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import UIKit

public enum MenuRow: TableRowProtocol {
    case suggestion
    case faq
    case support
    case logout
    
    public var icon: UIImage? {
        switch self {
        case .suggestion: return .lightbulbAlt
        case .faq: return .fileQuestionAlt
        case .support: return .commentsAlt
        case .logout: return .exit
        }
    }
    
    public var title: String {
        switch self {
        case .suggestion:
            return "menu_suggestions".localized(.olchaInvestCore)
        case .faq:
            return "menu_faq".localized(.olchaInvestCore)
        case .support:
            return "menu_help".localized(.olchaInvestCore)
        case .logout:
            return "menu_logout".localized(.olchaInvestCore)
        }
    }
}
