//
//  ProfileRow.swift
//  OlchaInvestCore
//
//  Created by Akhrorkhuja on 30/05/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import UIKit

public enum ProfileRow: TableRowProtocol {
    case olcha
    case ecoSystem
    case personal
    case cards
    case passport
    case security
    
    public var icon: UIImage? {
        switch self {
        case .olcha: return .olcha_market
        case .ecoSystem: return .olcha_market
        case .personal: return .userCircle
        case .cards: return .creditCard
        case .passport: return .filesLandscapesAlt
        case .security: return .lock
        }
    }
    
    public var title: String {
        switch self {
        case .olcha: return "Olcha"
        case .ecoSystem: return "Eco System"
        case .personal: return "profile_phone".localized(.olchaInvestCore)
        case .cards: return "profile_cards".localized(.olchaInvestCore)
        case .passport: return "profile_passport".localized(.olchaInvestCore)
        case .security: return "profile_security".localized(.olchaInvestCore)
        }
    }
}
