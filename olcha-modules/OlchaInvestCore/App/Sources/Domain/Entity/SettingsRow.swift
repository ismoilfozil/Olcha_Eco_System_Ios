//
//  SettingsRow.swift
//  OlchaInvestCore
//
//  Created by Akhrorkhuja on 31/05/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import UIKit

public enum SettingsRow {
    case language(language: String)
    case pushNotifications(isEnabled: Bool)
    case publicOffer(url: String?)
    case about
    case baseUrl(url: String?)
    case clearTooltipCache
    
    var title: String {
        switch self {
        case .language:
            return "settings_language".localized(.olchaInvestCore)
        case .pushNotifications:
            return "settings_push_notifications".localized(.olchaInvestCore)
        case .publicOffer:
            return "settings_public_offer".localized(.olchaInvestCore)
        case .about:
            return "settings_about_company".localized(.olchaInvestCore)
        case .baseUrl:
            return "BaseURL"
        case .clearTooltipCache:
            return "settings_clear_tooptip_cache".localized(.olchaInvestCore)
        }
    }
}
