//
//  LanguageRow.swift
//  OlchaInvestCore
//
//  Created by Akhrorkhuja on 31/05/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import Foundation

public enum LanguageRow: String {
    case ru
    case oz
    
    var title: String {
        switch self {
        case .ru: return "russian_language".localized(.olchaInvestCore)
        case .oz: return "uzbek_language".localized(.olchaInvestCore)
        }
    }
    
    var key: String {
        switch self {
        case .ru: return "ru"
        case .oz: return "oz"
        }
    }
}
