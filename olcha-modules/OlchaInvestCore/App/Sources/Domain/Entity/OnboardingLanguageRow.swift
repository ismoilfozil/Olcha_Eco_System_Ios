//
//  OnboardingLanguageRow.swift
//  OlchaInvestCore
//
//  Created by Akhrorkhuja on 15/06/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import UIKit

public enum OnboardingLanguageRow: TableRowProtocol {
    case ru
    case oz
    
    public var title: String {
        switch self {
        case .ru: return "russian_language".localized(.olchaInvestCore)
        case .oz: return "uzbek_cyrilic_language".localized(.olchaInvestCore)
        }
    }
    
    public var icon: UIImage? {
        switch self {
        case .ru: return .flagRu
        case .oz: return .flagUz
        }
    }
    
    public var key: String {
        switch self {
        case .ru: return "ru"
        case .oz: return "uz"
        }
    }
}
