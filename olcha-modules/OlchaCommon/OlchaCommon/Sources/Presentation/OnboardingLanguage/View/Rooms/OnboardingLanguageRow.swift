//
//  OnboardingLanguageRow.swift
//  OlchaInvestCore
//
//  Created by Akhrorkhuja on 15/06/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import UIKit
import OlchaUI
public enum OnboardingLanguageRow: RowProtocol {
    
    case ru
    case oz
    
    public var title: String {
        switch self {
        case .ru: return "russian_language".localized(.common)
        case .oz: return "uzbek_language".localized(.common)
        }
    }
    
    public var image: UIImage? {
        switch self {
        case .ru: return .flagRu
        case .oz: return .flagUz
        }
    }
    
    public var key: String {
        switch self {
        case .ru: return "ru"
        case .oz: return "oz"
        }
    }
}
